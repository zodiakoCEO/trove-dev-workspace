package
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import ui.ObjectPreview;

   // Fila de ingrediente de Redesigned - Crafting con búsqueda en el Market
   // (función portada de "Crafting item marketplace search").
   // Cambios respecto al original:
   //  - toda la fila es clicable (hit area transparente);
   //  - sin RegExp, buttonMode ni useHandCursor: con ellos el juego crasheaba
   //    al abrir el banco (Iggy no es Flash completo; usar solo APIs que ya use el mod);
   //  - mouseChildren = false: el target del evento siempre es la fila;
   //  - al pasar el ratón: fondo resaltado y lupa junto al nombre;
   //  - el nombre a buscar se guarda en itemName (no se lee del TextField).
   public class IngredientRow extends Sprite
   {

      public static const H:int = 55;

      public static const SIZE:int = 45;

      public static const NAME_W:int = 200;

      public static const BOX_W:int = 106;

      public static const ROW_W:int = SIZE + NAME_W + BOX_W * 2 + 10;

      public static const HOVER_COLOR:uint = 7583999;

      public var nameText:TextField;

      public var haveText:TextField;

      public var needText:TextField;

      public var _have:int = 0;

      public var _need:int = 0;

      public var data:int = -1;

      public var itemName:String = "";

      private var highlight:Shape = new Shape();

      private var loupe:Sprite = new Sprite();

      public function IngredientRow(param1:String, param2:String, param3:int, param4:int, param5:int)
      {
         super();
         this.data = param5;
         this._have = param3;
         this._need = param4;
         this.itemName = trim(param2);
         this.mouseChildren = false;
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,ROW_W,SIZE);
         this.graphics.endFill();
         renderer.rect(this.highlight,0,0,ROW_W,SIZE,renderer.GRAY_25,renderer.GRAY_34,0.6,1);
         this.highlight.visible = false;
         addChild(this.highlight);
         var _loc6_:ObjectPreview = new ObjectPreview(SIZE,SIZE);
         _loc6_.textureName = param1;
         _loc6_.mouseEnabled = false;
         addChild(_loc6_);
         this.nameText = renderer.text(SIZE,0,12,TextFieldAutoSize.LEFT,param2,NAME_W - 22,SIZE,true,false);
         this.nameText.y = (SIZE >> 1) - this.nameText.textHeight / 2 - 1;
         addChild(this.nameText);
         this.buildLoupe(SIZE + NAME_W - 12,(SIZE >> 1) - 2);
         var _loc7_:int = NAME_W + SIZE;
         var _loc9_:int = 30;
         var _loc10_:int = (SIZE >> 1) - (_loc9_ >> 1);
         var _loc11_:Shape = new Shape();
         addChild(_loc11_);
         renderer.rect(_loc11_,_loc7_,_loc10_,BOX_W,_loc9_,1315860,592137);
         renderer.outline(_loc11_,_loc7_ + 1,_loc10_ + 1,BOX_W - 2,_loc9_ - 2,renderer.GRAY_34);
         this.haveText = renderer.text(_loc7_,_loc10_ + 4,14,TextFieldAutoSize.CENTER,renderer.delimiter(param3),BOX_W,_loc9_,false,false);
         addChild(this.haveText);
         _loc7_ += BOX_W + 10;
         renderer.rect(_loc11_,_loc7_,_loc10_,BOX_W,_loc9_,1315860,592137);
         renderer.outline(_loc11_,_loc7_ + 1,_loc10_ + 1,BOX_W - 2,_loc9_ - 2,renderer.GRAY_34);
         this.needText = renderer.text(_loc7_,_loc10_ + 4,14,TextFieldAutoSize.CENTER,renderer.delimiter(param4),BOX_W,_loc9_,false,false);
         addChild(this.needText);
         this.update();
      }

      private static function trim(param1:String) : String
      {
         // Sin RegExp: Iggy (runtime de UI de Trove) no la soporta bien.
         if(param1 == null)
         {
            return "";
         }
         var _loc2_:int = 0;
         var _loc3_:int = param1.length;
         while(_loc2_ < _loc3_ && param1.charAt(_loc2_) == " ")
         {
            _loc2_++;
         }
         while(_loc3_ > _loc2_ && param1.charAt(_loc3_ - 1) == " ")
         {
            _loc3_--;
         }
         return param1.substr(_loc2_,_loc3_ - _loc2_);
      }

      // Misma lupa que dibuja Crafting.buildLoupe para el buscador de recetas.
      private function buildLoupe(param1:int, param2:int) : void
      {
         var _loc3_:int = 6;
         renderer.cercle(this.loupe,0,0,_loc3_,renderer.WHITE);
         renderer.cercle(this.loupe,0,0,_loc3_ - 1,renderer.GRAY_25);
         var _loc4_:Shape = new Shape();
         renderer.rectangle(_loc4_,0,-1,7,2,renderer.WHITE);
         _loc4_.rotation = 45;
         _loc4_.x = _loc3_ - 2;
         _loc4_.y = _loc3_ - 2;
         this.loupe.addChild(_loc4_);
         this.loupe.x = param1;
         this.loupe.y = param2;
         this.loupe.visible = false;
         addChild(this.loupe);
      }

      public function setHover(param1:Boolean) : void
      {
         this.highlight.visible = param1;
         this.loupe.visible = param1 && this.itemName.length > 0;
         this.nameText.textColor = param1 ? HOVER_COLOR : renderer.WHITE;
         this.nameText.alpha = 1;
      }

      public function setPressed(param1:Boolean) : void
      {
         this.nameText.alpha = param1 ? 0.65 : 1;
      }

      public function set have(param1:int) : void
      {
         this._have = param1;
         this.haveText.text = renderer.delimiter(param1);
         this.update();
      }

      public function get have() : int
      {
         return this._have;
      }

      public function set need(param1:int) : void
      {
         this._need = param1;
         this.needText.text = renderer.delimiter(param1);
         this.update();
      }

      public function get need() : int
      {
         return this._need;
      }

      public function update() : void
      {
         this.haveText.textColor = this._have < this._need ? 15093840 : 7583999;
      }
   }
}
