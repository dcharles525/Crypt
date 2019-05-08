public class ChartButtonGroup{

  public ChartButtonGroup(){

  }

  public Granite.Widgets.ModeButton createButtonGroup(string coinAbbrev, Caroline chart){

    var modeButton = new Granite.Widgets.ModeButton ();
    modeButton.append_text ("Hour");
    modeButton.append_text ("Day");
    modeButton.append_text ("Week");
    modeButton.set_active(0);

    modeButton.mode_changed.connect (mode => {

      if (modeButton.selected == 0){

        Coin tempCoinObject = new Coin();
        tempCoinObject.getPriceDataHour(coinAbbrev);

        chart.labelXList.clear();
        chart.dataTypeX = "m";
        chart.labelXList.add(1.to_string().concat(chart.dataTypeX));

        for (int i = 1; i < chart.DATA.length+1; i++){

          chart.labelXList.add((2*i).to_string().concat(chart.dataTypeX));

        }

        chart.DATA = tempCoinObject.DATA;
        chart.HIGH = tempCoinObject.HIGH;
        chart.LOW = tempCoinObject.LOW;
        chart.calculations();

      }

      if (modeButton.selected == 1){

        Coin tempCoinObject = new Coin();
        tempCoinObject.getPriceDataDay(coinAbbrev);

        chart.labelXList.clear();
        chart.dataTypeX = "h";
        chart.labelXList.add(1.to_string().concat(chart.dataTypeX));

        for (int i = 1; i < chart.DATA.length+1; i++){

          chart.labelXList.add((i).to_string().concat(chart.dataTypeX));

        }

        chart.DATA = tempCoinObject.DATA;
        chart.HIGH = tempCoinObject.HIGH;
        chart.LOW = tempCoinObject.LOW;
        chart.calculations();

      }

      if (modeButton.selected == 2){

        Coin tempCoinObject = new Coin();
        tempCoinObject.getPriceDataWeek(coinAbbrev);

        chart.labelXList.clear();
        chart.dataTypeX = "d";
        chart.labelXList.add(1.to_string().concat(chart.dataTypeX));

        for (int i = 1; i < chart.DATA.length+1; i++){

          chart.labelXList.add((i).to_string().concat(chart.dataTypeX));

        }

        chart.DATA = tempCoinObject.DATA;
        chart.HIGH = tempCoinObject.HIGH;
        chart.LOW = tempCoinObject.LOW;
        chart.calculations();

      }

    });

    return modeButton;

  }

}
