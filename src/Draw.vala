public class Draw: Gtk.Window{

  public double windowWidth;
  public double windowHeight;
  Coin coin = new Coin();

  public Draw(){

  }

  public Caroline drawLargeChartHour(string coinAbrv){

    var caroline = new Caroline();

    coin.getPriceDataHour(coinAbrv);
    caroline.width = 1300-550;
    caroline.height = (850/2)-20;
    caroline.spreadY = 10;
    caroline.lineThicknessTicks = 0.5;
    caroline.lineThicknessData = 1;
    caroline.lineThicknessTicks = 2;
    caroline.dataTypeY = "$";
    caroline.dataTypeX = "";
    caroline.gap = 0;
    caroline.min = 0;
    caroline.max = 0;
    caroline.DATA = coin.DATA;
    caroline.HIGH = coin.HIGH;
    caroline.LOW = coin.LOW;
    caroline.chartType = "line";

    caroline.labelXList.add(1.to_string().concat("h"));

    for (int i = 0; i < caroline.DATA.length; i++){

      caroline.labelXList.add((2*i).to_string().concat("m"));

    }

    caroline.calculations();

    return caroline;

  }

  public Caroline drawLargeChartDay(string coinAbrv){

    var caroline = new Caroline();

    coin.getPriceDataDay(coinAbrv);
    caroline.width = 1300-550;
    caroline.height = (850/2)-20;
    caroline.spreadY = 10;
    caroline.lineThicknessTicks = 0.5;
    caroline.lineThicknessData = 1;
    caroline.lineThicknessTicks = 2;
    caroline.dataTypeY = "$";
    caroline.dataTypeX = "";
    caroline.gap = 0;
    caroline.min = 0;
    caroline.max = 0;
    caroline.DATA = coin.DATA;
    caroline.HIGH = coin.HIGH;
    caroline.LOW = coin.LOW;
    caroline.chartType = "line";

    caroline.labelXList.add(1.to_string().concat("h"));

    for (int i = 0; i < caroline.DATA.length; i++){

      caroline.labelXList.add((i).to_string().concat("h"));

    }

    caroline.calculations();

    return caroline;

  }

  public Caroline drawLargeChartWeek(string coinAbrv){

    var caroline = new Caroline();

    coin.getPriceDataWeek(coinAbrv);
    caroline.width = 1300-550;
    caroline.height = (850/2)-20;
    caroline.spreadY = 10;
    caroline.lineThicknessTicks = 0.5;
    caroline.lineThicknessData = 1;
    caroline.lineThicknessTicks = 2;
    caroline.dataTypeY = "$";
    caroline.dataTypeX = "";
    caroline.gap = 0;
    caroline.min = 0;
    caroline.max = 0;
    caroline.DATA = coin.DATA;
    caroline.HIGH = coin.HIGH;
    caroline.LOW = coin.LOW;
    caroline.chartType = "line";

    caroline.labelXList.add(1.to_string().concat("h"));

    for (int i = 0; i < caroline.DATA.length; i++){

      caroline.labelXList.add((i).to_string().concat("d"));

    }

    caroline.calculations();

    return caroline;

  }

  public Caroline drawSmallChartHour(string coinAbrv){

    var caroline = new Caroline();

    coin.getPriceDataHour(coinAbrv);
    
    caroline.width = 550;
    caroline.height = 200;
    caroline.spreadY = 10;
    caroline.lineThicknessTicks = 0.5;
    caroline.lineThicknessData = 1;
    caroline.lineThicknessTicks = 2;
    caroline.dataTypeY = "$";
    caroline.dataTypeX = "";
    caroline.gap = 0;
    caroline.min = 0;
    caroline.max = 0;
    caroline.DATA = coin.DATA;
    caroline.HIGH = coin.HIGH;
    caroline.LOW = coin.LOW;
    caroline.chartType = "line";

    caroline.labelXList.add(1.to_string().concat("h"));

    for (int i = 0; i < caroline.DATA.length; i++){

      caroline.labelXList.add((2*i).to_string().concat("m"));

    }

    caroline.calculations();

    return caroline;

  }

  public Caroline drawSmallChartDay(string coinAbrv){

    var caroline = new Caroline();

    coin.getPriceDataDay(coinAbrv);

    caroline.width = 550;
    caroline.height = 200;
    caroline.spreadY = 10;
    caroline.lineThicknessTicks = 0.5;
    caroline.lineThicknessData = 1;
    caroline.lineThicknessTicks = 2;
    caroline.dataTypeY = "$";
    caroline.dataTypeX = "";
    caroline.gap = 0;
    caroline.min = 0;
    caroline.max = 0;
    caroline.DATA = coin.DATA;
    caroline.HIGH = coin.HIGH;
    caroline.LOW = coin.LOW;
    caroline.chartType = "line";

    caroline.labelXList.add(1.to_string().concat("h"));

    for (int i = 1; i < caroline.DATA.length+1; i++){

      caroline.labelXList.add((2*i).to_string().concat("m"));

    }

    caroline.calculations();

    return caroline;

  }

  public Caroline drawSmallChartWeek(string coinAbrv){

    var caroline = new Caroline();

    coin.getPriceDataWeek(coinAbrv);

    caroline.width = 550;
    caroline.height = 200;
    caroline.spreadY = 10;
    caroline.lineThicknessTicks = 0.5;
    caroline.lineThicknessData = 1;
    caroline.lineThicknessTicks = 2;
    caroline.dataTypeY = "$";
    caroline.dataTypeX = "";
    caroline.gap = 0;
    caroline.min = 0;
    caroline.max = 0;
    caroline.DATA = coin.DATA;
    caroline.HIGH = coin.HIGH;
    caroline.LOW = coin.LOW;
    caroline.chartType = "line";

    caroline.labelXList.add(1.to_string().concat("h"));

    for (int i = 1; i < caroline.DATA.length+1; i++){

      caroline.labelXList.add((2*i).to_string().concat("m"));

    }

    caroline.calculations();

    return caroline;

  }

}
