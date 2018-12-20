using Gtk;
using Cairo;
using Gee;

public class Caroline : Gtk.Window{

  public double[] DATA { get; set; }
  public double[] HIGH { get; set; }
  public double[] LOW { get; set; }
  public double width { get; set; }
  public double height { get; set; }
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

  public Caroline(){

  }

  public void calculations(){

    double[] tempDATAH = this.HIGH;
    double[] tempDATAL = this.LOW;
    tempDATAH = arraySortInt(tempDATAH);
    tempDATAL = arraySortInt(tempDATAL);
    double label;

    double temp = tempDATAH[tempDATAH.length-1];
    this.max = temp + 0.5;
    temp = tempDATAL[0];
    this.min = temp - 0.5;
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

  public DrawingArea createGraph () {

    var drawingArea = new DrawingArea ();
    drawingArea.draw.connect (onDraw);

    return drawingArea;

  }

  public delegate void DrawMethod ();

  public bool onDraw (Widget da, Context ctx) {

    //Line thickness for the plane (along with tolerance and color)
    ctx.set_tolerance (0.1);
    ctx.set_source_rgba (255, 255, 255,0.2);

    ctx.save ();
    ctx.new_path ();
    ctx.translate (1, 0);

    //draw plane
    drawPlane (ctx);

    ctx.stroke ();
    ctx.restore();

    //line thickness for ticks is set here
    ctx.set_line_width (this.lineThicknessTicks);

    ctx.save ();
    ctx.new_path ();
    ctx.translate (1, 0);

    //draw ticks
    drawTicksY (ctx);
    drawTicksX (ctx);

    ctx.stroke  ();
    ctx.restore ();

    //Line thickness for the data line (along with tolerance and color)
    ctx.set_line_width (this.lineThicknessData);
    ctx.set_tolerance (0.1);
    ctx.set_source_rgba (0, 174, 174,0.8);

    ctx.save ();
    ctx.new_path ();
    ctx.translate (1, 0);

    //drawing the line with the data
    if (this.chartType == "line"){

      drawLine (ctx);

    }

    if (this.chartType == "bar"){

      drawRectangles(ctx);

    }

    ctx.stroke ();
    ctx.restore();

    return true;

  }

  public void drawPlane (Context ctx) {

    ctx.move_to (15, 15);
    ctx.line_to (15, this.height+15);

    ctx.move_to (this.width+15, this.height+15);
    ctx.line_to (15, this.height+15);

  }

  public void drawTicksY(Context ctx){

    double spreadFinal = this.height/this.spreadY;

    for (int i = 0; i < this.spreadY+1; i++){

      ctx.move_to (-10, this.height+15-(spreadFinal*i));
      ctx.line_to (25, this.height+15-(spreadFinal*i));

      ctx.move_to (0, this.height+15-(spreadFinal*i));
      ctx.show_text(this.dataTypeY.concat(this.labelYList.get(i)));

    }

  }

  public void drawTicksX(Context ctx){

    double spreadFinal = this.width/this.DATA.length;

    for (int i = 1; i < this.DATA.length+1; i++){

      ctx.move_to (15+spreadFinal*i, this.height+20);
      ctx.line_to (15+spreadFinal*i, this.height+5);

      ctx.move_to (11+spreadFinal*i, this.height+30);
      ctx.show_text(this.labelXList.get(i));

    }

  }

  public void drawLine(Context ctx){

    double spreadFinalX = this.width/this.DATA.length;
    double spreadFinalY = this.height/this.spreadY;

    double scaler = (this.DATA[0] - this.min) / (this.max - this.min);
    scaler = scaler * this.spreadY;
    double startingHeight = (this.height+15)-((spreadFinalY*scaler));
    ctx.move_to (15,startingHeight);

    for (int i = 1; i < this.DATA.length; i++){

      scaler = (this.DATA[i] - this.min) / (this.max - this.min);
      scaler = scaler * this.spreadY;

      ctx.line_to ((15+spreadFinalX*(i+1)),((this.height+15)-((spreadFinalY*scaler))));

    }

    ctx.stroke  ();

    double scalerCandleH = 0;
    double candleChangeH = 0;

    double scalerCandleL = 0;
    double candleChangeL = 0;

    double finalCandleScaler = 0;

    for (int i = 0; i < this.DATA.length; i++){

      if (this.DATA[i] > this.DATA[i-1]){

        ctx.set_source_rgba (0, 255, 0,0.5);

      }else{

        ctx.set_source_rgba (255, 0, 0,0.5);

      }

      scalerCandleH = (this.HIGH[i] - this.min) / (this.max - this.min);
      scalerCandleH = scalerCandleH * this.spreadY;

      scalerCandleL = (this.LOW[i] - this.min) / (this.max - this.min);
      scalerCandleL = scalerCandleL * this.spreadY;

      double yUpdated = ((this.height+15)-((spreadFinalY*scalerCandleH)))-((this.height+15)-((spreadFinalY*scalerCandleL)));
      ctx.rectangle ((17.5+spreadFinalX*(i+1))-7.5, ((this.height+15)-((spreadFinalY*scalerCandleL))), 10, yUpdated);

      ctx.stroke  ();

    }

  }

  public void drawRectangles(Context ctx){

    double spreadFinalX = this.width/this.DATA.length;
    double spreadFinalY = this.height/this.spreadY;

    double scaler = (this.DATA[0] - this.min) / (this.max - this.min);
    scaler = scaler * this.spreadY;

    for (int i = 0; i < this.DATA.length; i++){

      scaler = (this.DATA[i] - this.min) / (this.max - this.min);
      scaler = scaler * this.spreadY;

      ctx.rectangle ((17.5+spreadFinalX*(i+1))-7.5, this.height+15, 10, -((this.height)-((spreadFinalY*scaler))));

      ctx.stroke  ();

    }

  }

}
