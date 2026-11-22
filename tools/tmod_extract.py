"""Extrae un .tmod de Trove sin usar el devtool.

Uso: python tools/tmod_extract.py <archivo.tmod> <carpeta_destino>

Formato (deducido de los .tmod reales):
  u64  tamaño de la cabecera (los datos empiezan en ese offset)
  u16  versión, u16 número de propiedades
  propiedades: pares (clave, valor) de strings con longitud varint
  entradas hasta el final de la cabecera: nombre (string), archivo (varint),
      offset (varint), tamaño (varint), hash (varint)
  datos: un stream zlib con todos los archivos concatenados
Escribe también <destino>/tmod_meta.txt con las propiedades y la tabla de archivos.
"""
import struct
import sys
import zlib
from pathlib import Path


def varint(buf, pos):
    result = shift = 0
    while True:
        b = buf[pos]
        pos += 1
        result |= (b & 0x7F) << shift
        if not b & 0x80:
            return result, pos
        shift += 7


def string(buf, pos):
    n, pos = varint(buf, pos)
    return buf[pos:pos + n].decode("utf-8"), pos + n


def inflate_tolerant(raw):
    """Descomprime byte a byte para conservar todo lo leído antes de un error."""
    dec, out = zlib.decompressobj(), []
    try:
        out.append(dec.decompress(raw))
        return b"".join(out)
    except zlib.error:
        pass
    dec, out = zlib.decompressobj(), []
    for i in range(len(raw)):
        try:
            out.append(dec.decompress(raw[i:i + 1]))
        except zlib.error:
            break
    return b"".join(out)


def parse(data):
    header_size, version, nprops = struct.unpack_from("<QHH", data, 0)
    pos = 12
    props = {}
    for _ in range(nprops):
        k, pos = string(data, pos)
        v, pos = string(data, pos)
        props[k] = v
    entries = []
    while pos < header_size:
        name, pos = string(data, pos)
        archive, pos = varint(data, pos)
        offset, pos = varint(data, pos)
        size, pos = varint(data, pos)
        hsh, pos = varint(data, pos)
        entries.append((name, archive, offset, size, hsh))
    # El stream suele terminar con un flush sin bloque final, así que
    # zlib.decompress() lo da por truncado; decompressobj sí lo lee entero.
    # Algunos .tmod traen basura/relleno tras el último bloque: se lee por
    # trozos y se conserva todo lo descomprimido antes del error.
    payload = inflate_tolerant(data[header_size:])
    need = max((o + s for _, _, o, s, _ in entries), default=0)
    if len(payload) < need:
        raise SystemExit(f"datos incompletos: {len(payload)} < {need} bytes")
    return version, props, entries, payload


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    src, dst = Path(sys.argv[1]), Path(sys.argv[2])
    version, props, entries, payload = parse(src.read_bytes())
    dst_resolved = dst.resolve()
    lines = [f"source: {src.name}", f"version: {version}"]
    lines += [f"{k}: {v}" for k, v in props.items()]
    lines.append("files:")
    for name, archive, offset, size, hsh in entries:
        out = (dst / name).resolve()
        if dst_resolved not in out.parents:
            raise SystemExit(f"ruta insegura en el paquete: {name}")
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(payload[offset:offset + size])
        lines.append(f"  {name}  size={size} offset={offset} archive={archive} hash={hsh:#x}")
    (dst / "tmod_meta.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
