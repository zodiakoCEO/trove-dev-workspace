package
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import ui.*;

   // Lista de ingredientes. Clic en un ingrediente = buscarlo en el Market
   // (trove://marketplace/search, igual que "Crafting item marketplace search").
   public class Ingredient extends Sprite
   {

      public var list:Vector.<IngredientRow> = new Vector.<IngredientRow>();

      private var hovered:IngredientRow = null;

      public function Ingredient()
      {
         super();
         this.addEventListener(MouseEvent.CLICK,this.onClick);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         this.addEventListener(Event.MOUSE_LEAVE,this.onOut);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onUp);
         this.setup();
      }

      public function getCount() : Array
      {
         if(this.list.length == 0)
         {
            return [0,0];
         }
         var _loc1_:IngredientRow = this.list[0];
         return [_loc1_.have,_loc1_.need];
      }

      public function add(param1:String, param2:String, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:IngredientRow = new IngredientRow(param1,param2,param3,param4,param5);
         _loc6_.y = this.list.length * IngredientRow.H;
         addChild(_loc6_);
         this.list.push(_loc6_);
      }

      private function onHave(param1:int, param2:int) : void
      {
         var _loc3_:IngredientRow = this.find(param1);
         if(_loc3_)
         {
            _loc3_.have = param2;
         }
      }

      private function onNeed(param1:int, param2:int) : void
      {
         var _loc3_:IngredientRow = this.find(param1);
         if(_loc3_)
         {
            _loc3_.need = param2;
         }
      }

      private function find(param1:int) : IngredientRow
      {
         var _loc2_:IngredientRow = null;
         for each(_loc2_ in this.list)
         {
            if(_loc2_.data == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }

      private function setup() : void
      {
         ExternalInterface.addCallback("ADD_INGREDIENT",this.add);
         ExternalInterface.addCallback("INGREDIENT_COUNT_CHANGED",this.onHave);
         ExternalInterface.addCallback("INGREDIENT_QUANTITY_CHANGED",this.onNeed);
         ExternalInterface.addCallback("RESET_INGREDIENTS",this.clear);
      }

      public function clear() : void
      {
         if(this.hovered)
         {
            ExternalInterface.call("SLOT.POINTER_LEAVE",this.hovered.data);
            this.hovered = null;
         }
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this.list = new Vector.<IngredientRow>();
      }

      public function onOver(param1:MouseEvent) : void
      {
         var _loc3_:Point = null;
         var _loc2_:IngredientRow = param1.target as IngredientRow;
         if(_loc2_)
         {
            this.hovered = _loc2_;
            _loc2_.setHover(true);
            _loc3_ = _loc2_.localToGlobal(new Point(0,IngredientRow.SIZE));
            ExternalInterface.call("SLOT.POINTER_ENTER",_loc2_.data,_loc3_.x,_loc3_.y);
         }
      }

      public function onOut(param1:Event) : void
      {
         var _loc2_:IngredientRow = param1.target as IngredientRow;
         if(!_loc2_)
         {
            _loc2_ = this.hovered;
         }
         if(_loc2_)
         {
            _loc2_.setHover(false);
            ExternalInterface.call("SLOT.POINTER_LEAVE",_loc2_.data);
            if(_loc2_ == this.hovered)
            {
               this.hovered = null;
            }
         }
      }

      public function onDown(param1:MouseEvent) : void
      {
         var _loc2_:IngredientRow = param1.target as IngredientRow;
         if(_loc2_)
         {
            _loc2_.setPressed(true);
         }
      }

      public function onUp(param1:MouseEvent) : void
      {
         var _loc2_:IngredientRow = param1.target as IngredientRow;
         if(_loc2_)
         {
            _loc2_.setPressed(false);
         }
      }

      public function onClick(param1:MouseEvent) : void
      {
         var _loc2_:IngredientRow = param1.target as IngredientRow;
         if(_loc2_ && _loc2_.itemName.length > 0)
         {
            ExternalInterface.call("OPENURL",geo.URL + _loc2_.itemName);
         }
      }
   }
}
