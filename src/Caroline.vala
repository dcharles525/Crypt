using Gtk;
using Cairo;
using Gee;

public class Caroline : Gtk.DrawingArea {

  private Pango.Layout layout;
  private bool drawLabel { get; set; }
  private int orderPosition { get; set; }
  private double[] candlePositionX = {};
  private double[] candlePositionY = {};
  private double[] candleHeight = {};

  public double[] DATA = {};
  public double[] HIGH = {};
  public double[] LOW = {};
  public int width { get; set; }
  public int height { get; set; }
  public double lineThicknessTicks { get; set; }
  public double lineThicknessPlane { get; set; }
  public double lineThicknessData { get; set; }
  public double spreadY { get; set; }
  public string dataTypeY{ get; set; }
  public string dataTypeX { get; set; }
  public ArrayList<string> labelYList = new ArrayList<string>();
  public ArrayList<string> labelXList = new ArrayList<string>();
  public double gap { get; set; }
  public double max { get; set; }
  public double min { get; set; }
  public string chartType;
  public Context ctx;
  public DrawingArea drawingArea = new DrawingArea();

  construct{
    this.layout = create_pango_layout ("");
    this.drawLabel = false;
  }

  public Caroline(){

    add_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.POINTER_MOTION_MASK);
    set_size_request (this.width, this.height);

  }

  public void calculations(){

    double[] tempDATAH = this.HIGH;
    double[] tempDATAL = this.LOW;
    tempDATAH = arraySortInt(tempDATAH);
    tempDATAL = arraySortInt(tempDATAL);
    double label;
    this.labelYList.clear();

    double temp = tempDATAH[tempDATAH.length-1];

    this.max = temp + (temp * 0.001);
    temp = tempDATAL[0];
    this.min = temp - (temp * 0.001);
    double difference = this.max - this.min;
    this.gap = difference / this.spreadY;
    label = this.min;

    if (label.to_string().length >= 8){

      this.labelYList.add(label.to_string().slice (0, 8));

    }else{

      this.labelYList.add(label.to_string());

    }

    for (int i = 1; i < this.spreadY+1; i++){

      label = label+gap;

      if (label.to_string().length >= 8){

        this.labelYList.add(label.to_string().slice (0, 8));

      }else{

        this.labelYList.add(label.to_string());

      }

    }

    this.queue_draw();

  }

  private void calculateClickableArea(){

    int width = get_allocated_width () - 50;
    int height = get_allocated_height () - 50;
    double scalerCandleH = 0;
    double scalerCandleL = 0;

    double spreadFinalX = width/this.DATA.length;
    double spreadFinalY = height/this.spreadY;

    this.candlePositionX = {};
    this.candlePositionY = {};
    this.candleHeight = {};

    for (int i = 0; i < this.DATA.length; i++){

      scalerCandleH = (this.HIGH[i] - this.min) / (this.max - this.min);
      scalerCandleH = scalerCandleH * this.spreadY;

      scalerCandleL = (this.LOW[i] - this.min) / (this.max - this.min);
      scalerCandleL = scalerCandleL * this.spreadY;

      double yUpdated = ((height+15)-((spreadFinalY*scalerCandleH)))-((height+15)-((spreadFinalY*scalerCandleL)));

      this.candlePositionX += (17.5+spreadFinalX*(i+1))-7.5;
      this.candlePositionY += ((height+15)-((spreadFinalY*scalerCandleL)));
      this.candleHeight += yUpdated;

    }

  }

  public double[] arraySortInt(double[] array){

    bool swapped = true;
    int j = 0;
    double tmp;

    while (swapped) {

      swapped = false;
      j++;

      for (int i = 0; i < array.length - j; i++) {

        if (array[i] > array[i + 1]) {
          tmp = array[i];
          array[i] = array[i + 1];
          array[i + 1] = tmp;
          swapped = true;
        }

      }

    }

    return array;

  }

  public override bool draw (Cairo.Context cr) {

    int width = get_allocated_width() - 50;
    int height = get_allocated_height() - 50;

    cr.set_line_width (this.lineThicknessTicks);
    cr.set_source_rgba (255, 255, 255,0.2);
    cr.move_to (15, 15);
    cr.line_to (15, height + 15);

    cr.move_to (width + 15, height + 15);
    cr.line_to (15, height + 15);
    cr.stroke ();

    cr.new_path ();
    cr.set_line_width (this.lineThicknessTicks);

    double spreadFinal = height/this.spreadY;

    for (int i = 1; i < this.spreadY + 1; i++){

      cr.move_to (-10, height+15-(spreadFinal*i));
      cr.line_to (25, height+15-(spreadFinal*i));

      cr.move_to (0, height+15-(spreadFinal*i));

      cr.show_text(this.dataTypeY.concat(this.labelYList.get(i)));

    };

    spreadFinal = width/this.DATA.length;

    for (int i = 1; i < this.DATA.length + 1; i++){

      cr.move_to (15+spreadFinal*i, height+20);
      cr.line_to (15+spreadFinal*i, height+5);

      cr.move_to (11+spreadFinal*i, height+30);
      cr.show_text(this.labelXList.get(i));

    }

    cr.stroke ();
    cr.restore ();
    cr.save();

    double spreadFinalX = width/this.DATA.length;
    double spreadFinalY = height/this.spreadY;
    cr.set_line_width (this.lineThicknessData);
    cr.set_source_rgba (0, 174, 174,0.8);

    double scaler = (this.DATA[0] - this.min) / (this.max - this.min);
    scaler = scaler * this.spreadY;
    double startingHeight = (height+15)-((spreadFinalY*scaler));
    cr.move_to (15,startingHeight);

    for (int i = 1; i < this.DATA.length; i++){

      scaler = (this.DATA[i] - this.min) / (this.max - this.min);
      scaler = scaler * this.spreadY;

      cr.line_to ((15+spreadFinalX*(i+1)),((height+15)-((spreadFinalY*scaler))));

    }

    cr.stroke ();

    double scalerCandleH = 0;
    double scalerCandleL = 0;

    this.candlePositionX = {};
    this.candlePositionY = {};
    this.candleHeight = {};

    for (int i = 0; i < this.DATA.length; i++){

      if (this.DATA[i] > this.DATA[i-1]){

        cr.set_source_rgba (0, 255, 0,0.5);

      }else{

        cr.set_source_rgba (255, 0, 0,0.5);

      }

      scalerCandleH = (this.HIGH[i] - this.min) / (this.max - this.min);
      scalerCandleH = scalerCandleH * this.spreadY;

      scalerCandleL = (this.LOW[i] - this.min) / (this.max - this.min);
      scalerCandleL = scalerCandleL * this.spreadY;

      double yUpdated = ((height+15)-((spreadFinalY*scalerCandleH)))-((height+15)-((spreadFinalY*scalerCandleL)));

      cr.rectangle ((17.5+spreadFinalX*(i+1))-7.5, ((height+15)-((spreadFinalY*scalerCandleL))), 10, yUpdated);

      candlePositionX += (17.5+spreadFinalX*(i+1))-7.5;
      candlePositionY += ((height+15)-((spreadFinalY*scalerCandleL)));
      candleHeight += yUpdated;

      cr.stroke ();

    }

    if (this.drawLabel){

      int fontw, fonth;
      string tempFinal = "";

      cr.set_source_rgba (0, 0, 0,0.4);
      cr.rectangle (40, 0, 117, 68);
      cr.fill();
      cr.stroke();

      cr.set_source_rgba (0, 255, 0,1);
      this.layout = null;
      string temp = _("High: ").concat(this.HIGH[this.orderPosition].to_string());
      string[] tempArray = temp.split(".");

      if (tempArray[1].length > 2){

        tempFinal = tempArray[0].concat(".",tempArray[1].substring(0,2));

      }else{

        tempFinal = tempArray[0].concat(".",tempArray[1]);

      }

      this.layout = create_pango_layout (tempFinal);
      this.layout.get_pixel_size (out fontw, out fonth);

      cr.move_to (55,10);
      Pango.cairo_update_layout (cr, this.layout);
      Pango.cairo_show_layout (cr, this.layout);
      this.queue_draw();

      cr.set_source_rgba (255, 0, 0,1);
      this.layout = null;
      temp = _("Low: ").concat(this.LOW[this.orderPosition].to_string());
      tempArray = temp.split(".");

      if (tempArray[1].length > 2){

        tempFinal = tempArray[0].concat(".",tempArray[1].substring(0,2));

      }else{

        tempFinal = tempArray[0].concat(".",tempArray[1]);

      }

      this.layout = create_pango_layout (tempFinal);
      this.layout.get_pixel_size (out fontw, out fonth);

      cr.move_to (55,25);
      Pango.cairo_update_layout (cr, this.layout);
      Pango.cairo_show_layout (cr, this.layout);
      this.queue_draw();

      cr.set_source_rgba (255, 255, 255,1);
      this.layout = null;
      temp = _("Current: ").concat(this.DATA[this.orderPosition].to_string());
      tempArray = temp.split(".");

      if (tempArray[1].length > 2){

        tempFinal = tempArray[0].concat(".",tempArray[1].substring(0,2));

      }else{

        tempFinal = tempArray[0].concat(".",tempArray[1]);

      }

      this.layout = create_pango_layout (tempFinal);
      this.layout.get_pixel_size (out fontw, out fonth);

      cr.move_to (55,40);
      Pango.cairo_update_layout (cr, this.layout);
      Pango.cairo_show_layout (cr, this.layout);
      this.queue_draw();

    }

    this.button_press_event.connect ((event) => {

      int found = 0;

      for (int g = 0; g < this.DATA.length; g++){

        if (event.x >= candlePositionX[g] && event.x <= (candlePositionX[g] + 10)){

          if (event.y >= (candlePositionY[g] + candleHeight[g]) && event.y <= (candlePositionY[g])){

            this.orderPosition = g;
            this.drawLabel = true;
            found = 1;

          }

        }

      }

      if (found == 0){

        this.drawLabel = false;

      }

      return true;
    });

    return true;

  }

  public override void size_allocate (Gtk.Allocation allocation) {

    this.calculateClickableArea();
    this.drawLabel = false;
    this.layout = create_pango_layout ("");
    base.size_allocate (allocation);

  }

}
