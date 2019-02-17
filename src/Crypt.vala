using Soup;
using Gtk;
using Json;
using WebKit;
using Gee;
using Cairo;

/*
- Split up code and condense it
- remove warnings and errors
- make sure numbers don't go null because of length
*/
//valac --pkg gtk+-3.0 --pkg libsoup-2.4 --pkg json-glib-1.0 --pkg webkit2gtk-4.0 --pkg gee-0.8 --pkg gstreamer-1.0 Crypt.vala

public class Crypt: Gtk.Window{

  public double windowWidth;
  public double windowHeight;
  public Gtk.Window window = new Gtk.Window();
  public Gtk.Notebook notebook = new Gtk.Notebook();
  public Gtk.ComboBoxText comboBox = new Gtk.ComboBoxText();
  public Caroline caroline = new Caroline();
  public Gtk.CssProvider provider = new Gtk.CssProvider();
  public Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
  public Gtk.Box secondaryBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
  public Gtk.Grid chartGrid = new Gtk.Grid ();
  public Gtk.Grid mainGrid = new Gtk.Grid ();
  public MainLoop m = new MainLoop();
  public Coin currentCoin = new Coin();
  public Coin currentCoinHour = new Coin();
  public Draw drawClass = new Draw();
  public Gtk.Spinner spinner = new Gtk.Spinner();
  private double[] DATA = {};
  private double[] HIGH = {};
  private double[] LOW = {};
  public int signalDampener = 0;
  public int signalDampenerSecondary = 0;
  public string defaultCoin = "";
  public string CODE_STYLE = """
    .box{
      padding-left: 10px;
    }

    .area{
      padding: 10px;
      background-color: #3a3f44;
    }

    .padding-top{
      padding-top: 10px;
    }

    .title-text{
      font-size: 20px;
    }

    .large-text{
      font-size: 18px;
    }

    .sub-text-coin-view{
      font-size: 14px;
    }

    .price-text{
      font-size: 18px;
      color: #00db3c;
    }

    .price-red-text{
      font-size: 18px;
      color: #ff0000;
    }

    .price-blue-text{
      font-size: 18px;
      color: #00aeae;
    }

    .button-color{
      background-image: linear-gradient( #1c9cc4, #1c8dc4);
    }
  """;

  public void getCoins(){

    this.comboBox = new Gtk.ComboBoxText ();
    this.comboBox.append("0","BTC");
    this.comboBox.append("1","LTC");
    this.comboBox.append("2","ETH");
    this.comboBox.append("3","BCH");
    this.comboBox.append("4","XMR");
    this.comboBox.append("5","DASH");
    this.comboBox.append("6","ZEC");
    this.comboBox.append("7","ETC");
    this.comboBox.active = 0;

  }

  public void addCoinTab(string coinAbrv){

    this.spinner.active = true;
    Gtk.Grid coinGridHorizontal = new Gtk.Grid ();

    this.currentCoin.getCoinInfoFull(coinAbrv);
    this.windowHeight = 600;

    Gtk.Label priceTitle = new Gtk.Label (coinAbrv
    .concat(": ",this.currentCoin.price.to_string()," | ",this.currentCoin.change24Hour.to_string(),
    " | ",this.currentCoin.changeP24Hour.to_string()));
    priceTitle.get_style_context().add_class("title-text");
    priceTitle.get_style_context().add_class("padding-top");
    Gtk.Label price = new Gtk.Label (_("Price: " + this.currentCoin.price));
    Gtk.Label lastUpdate = new Gtk.Label (_("Last Update: " + this.currentCoin.lastUpdate));
    Gtk.Label lastVolume = new Gtk.Label (_("Last Volume: " + this.currentCoin.lastVolume));
    Gtk.Label lastVolumeTo = new Gtk.Label (_("Last Volume To: " + this.currentCoin.lastVolumeTo));
    Gtk.Label lastTradeID = new Gtk.Label (_("Last TradeID: " + this.currentCoin.lastTradeID));
    Gtk.Label volumeDay = new Gtk.Label (_("Volume Day: " + this.currentCoin.volumeDay));
    Gtk.Label volumeDayTo = new Gtk.Label (_("Volume Day To: " + this.currentCoin.volumeDayTo));
    Gtk.Label volume24Hour = new Gtk.Label (_("Volume 24 Hour: " + this.currentCoin.volume24Hour));
    Gtk.Label volume24HourTo = new Gtk.Label (_("Volume 24 Hour To: " + this.currentCoin.volume24HourTo));
    Gtk.Label openDay = new Gtk.Label (_("Open Day: " + this.currentCoin.openDay));
    Gtk.Label highDay = new Gtk.Label (_("Open High Day: " + this.currentCoin.highDay));
    Gtk.Label lowDay = new Gtk.Label (_("Open Low Day: " + this.currentCoin.lowDay));
    Gtk.Label open24Hour = new Gtk.Label (_("Open 24h: " + this.currentCoin.open24Hour));
    Gtk.Label high24Hour = new Gtk.Label (_("Open High 24h: " + this.currentCoin.high24Hour));
    Gtk.Label low24Hour = new Gtk.Label (_("Open Low 24h: " + this.currentCoin.high24Hour));
    Gtk.Label lastMarket = new Gtk.Label (_("Last Market: " + this.currentCoin.lastMarket));
    Gtk.Label change24Hour = new Gtk.Label (_("Change Last 24h: " + this.currentCoin.change24Hour));
    Gtk.Label changeP24Hour = new Gtk.Label (_("Change Percent Last 24h: " + this.currentCoin.changeP24Hour));
    Gtk.Label changeDay = new Gtk.Label (_("Change Day: " + this.currentCoin.changeDay));
    Gtk.Label changePDay = new Gtk.Label (_("Change Percent Day: " + this.currentCoin.changePDay));
    Gtk.Label supply = new Gtk.Label (_("Supply: " + this.currentCoin.supply));
    Gtk.Label mCap = new Gtk.Label (_("Market Cap: " + this.currentCoin.mCap));
    Gtk.Label totalVolume24Hour = new Gtk.Label (_("Total Volume 24h: " + this.currentCoin.totalVolume24Hour));
    Gtk.Label totalVolume24HTo = new Gtk.Label (_("Total Volume 24h To: " + this.currentCoin.totalVolume24HTo));
    price.get_style_context().add_class("sub-text-coin-view");
    price.xalign = 0;
    lastUpdate.get_style_context().add_class("sub-text-coin-view");
    lastUpdate.xalign = 0;
    lastVolume.get_style_context().add_class("sub-text-coin-view");
    lastVolume.xalign = 0;
    lastVolumeTo.get_style_context().add_class("sub-text-coin-view");
    lastVolumeTo.xalign = 0;
    lastTradeID.get_style_context().add_class("sub-text-coin-view");
    lastTradeID.xalign = 0;
    volumeDay.get_style_context().add_class("sub-text-coin-view");
    volumeDay.xalign = 0;
    volumeDayTo.get_style_context().add_class("sub-text-coin-view");
    volumeDayTo.xalign = 0;
    volume24Hour.get_style_context().add_class("sub-text-coin-view");
    volume24Hour.xalign = 0;
    volume24HourTo.get_style_context().add_class("sub-text-coin-view");
    volume24HourTo.xalign = 0;
    openDay.get_style_context().add_class("sub-text-coin-view");
    openDay.xalign = 0;
    highDay.get_style_context().add_class("sub-text-coin-view");
    highDay.xalign = 0;
    lowDay.get_style_context().add_class("sub-text-coin-view");
    lowDay.xalign = 0;
    open24Hour.get_style_context().add_class("sub-text-coin-view");
    open24Hour.xalign = 0;
    high24Hour.get_style_context().add_class("sub-text-coin-view");
    high24Hour.xalign = 0;
    low24Hour.get_style_context().add_class("sub-text-coin-view");
    low24Hour.xalign = 0;
    lastMarket.get_style_context().add_class("sub-text-coin-view");
    lastMarket.xalign = 0;
    change24Hour.get_style_context().add_class("sub-text-coin-view");
    change24Hour.xalign = 0;
    changeP24Hour.get_style_context().add_class("sub-text-coin-view");
    changeP24Hour.xalign = 0;
    changeDay.get_style_context().add_class("sub-text-coin-view");
    changeDay.xalign = 0;
    changePDay.get_style_context().add_class("sub-text-coin-view");
    changePDay.xalign = 0;
    supply.get_style_context().add_class("sub-text-coin-view");
    supply.xalign = 0;
    mCap.get_style_context().add_class("sub-text-coin-view");
    mCap.xalign = 0;
    totalVolume24Hour.get_style_context().add_class("sub-text-coin-view");
    totalVolume24Hour.xalign = 0;
    totalVolume24HTo.get_style_context().add_class("sub-text-coin-view");
    totalVolume24HTo.xalign = 0;

    Gtk.Box verticalBoxSecondary = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    Gtk.Box verticalBoxSecondaryMain = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    verticalBoxSecondaryMain.pack_start(priceTitle,false,false);
    verticalBoxSecondaryMain.pack_start(price,false,false);
    verticalBoxSecondaryMain.pack_start(lastUpdate,false,false);
    verticalBoxSecondaryMain.pack_start(lastVolume,false,false);
    verticalBoxSecondaryMain.pack_start(lastVolumeTo,false,false);
    verticalBoxSecondaryMain.pack_start(lastTradeID,false,false);
    verticalBoxSecondaryMain.pack_start(volumeDay,false,false);
    verticalBoxSecondaryMain.pack_start(volumeDayTo,false,false);
    verticalBoxSecondaryMain.pack_start(volume24Hour,false,false);
    verticalBoxSecondaryMain.pack_start(volume24HourTo,false,false);
    verticalBoxSecondaryMain.pack_start(openDay,false,false);
    verticalBoxSecondaryMain.pack_start(highDay,false,false);
    verticalBoxSecondaryMain.pack_start(lowDay,false,false);
    verticalBoxSecondaryMain.pack_start(open24Hour,false,false);
    verticalBoxSecondaryMain.pack_start(high24Hour,false,false);
    verticalBoxSecondaryMain.pack_start(low24Hour,false,false);
    verticalBoxSecondaryMain.pack_start(lastMarket,false,false);
    verticalBoxSecondaryMain.pack_start(change24Hour,false,false);
    verticalBoxSecondaryMain.pack_start(changeP24Hour,false,false);
    verticalBoxSecondaryMain.pack_start(changeDay,false,false);
    verticalBoxSecondaryMain.pack_start(changePDay,false,false);
    verticalBoxSecondaryMain.pack_start(supply,false,false);
    verticalBoxSecondaryMain.pack_start(mCap,false,false);
    verticalBoxSecondaryMain.pack_start(totalVolume24Hour,false,false);
    verticalBoxSecondaryMain.pack_start(totalVolume24HTo,false,false);

    Gtk.ScrolledWindow scrolledStats = new Gtk.ScrolledWindow (null, null);
    scrolledStats.set_max_content_width(200);
    scrolledStats.set_min_content_height(300);
    scrolledStats.add(verticalBoxSecondaryMain);

    Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/v2/news/?lang=EN&categories=".concat(coinAbrv));
		session.send_message (message);
    Gtk.Box newsBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    newsBox.set_spacing(10);
    Gtk.ScrolledWindow scrolledNews = new Gtk.ScrolledWindow (null, null);

    Gtk.Label currentNewsLabel = new Gtk.Label (_("Current ").concat(coinAbrv,_(" News")));
    currentNewsLabel.get_style_context().add_class("title-text");
    currentNewsLabel.get_style_context().add_class("padding-top");

    newsBox.pack_start(currentNewsLabel);

		try {

			var parser = new Json.Parser ();
      parser.load_from_data((string) message.response_body.flatten().data, -1);
      var root_object = parser.get_root ().get_object ();
      var response = root_object.get_array_member("Data");

      foreach (var news in response.get_elements()) {

        var newsObject = news.get_object();

        Gtk.Label titleLabel = new Gtk.Label (newsObject.get_string_member("title"));
        Gtk.Label linkLabel = new Gtk.Label (newsObject.get_string_member("url"));
        linkLabel.set_markup("<a href='".concat(newsObject.get_string_member("url"),"'>",newsObject.get_string_member("url"),"</a>"));
        titleLabel.set_alignment(0,0);
        titleLabel.set_line_wrap(true);
        titleLabel.set_line_wrap_mode(Pango.WrapMode.WORD_CHAR);
        titleLabel.set_max_width_chars(100);
        linkLabel.set_alignment(0,0);
        linkLabel.set_use_markup(true);
        linkLabel.set_line_wrap(true);
        linkLabel.set_selectable(true);
        linkLabel.set_line_wrap_mode(Pango.WrapMode.WORD_CHAR);
        linkLabel.set_max_width_chars(100);

        newsBox.pack_start(titleLabel);
        newsBox.pack_start(linkLabel);
        newsBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

      }

    }catch (Error e) {

      stderr.printf (_("Something is wrong in getNewsMainPage"));

    }

    scrolledNews.set_max_content_width(200);
    scrolledNews.set_min_content_height(300);
    scrolledNews.add(newsBox);

    verticalBoxSecondary.pack_end(scrolledNews);
    verticalBoxSecondary.pack_end(scrolledStats);

    Caroline hourLineChart = drawClass.drawLargeChartHour(coinAbrv,((int)this.windowWidth) - 50,(int)(this.windowHeight/2) - 50);
    Caroline dayLineChart = drawClass.drawLargeChartDay(coinAbrv,((int)this.windowWidth) - 50,(int)(this.windowHeight/3) - 50);
    Caroline weekLineChart = drawClass.drawLargeChartWeek(coinAbrv,((int)this.windowWidth) - 50,(int)(this.windowHeight/3) - 50);

    Timeout.add(500,()=>{
      hourLineChart.queue_draw();
      dayLineChart.queue_draw();
      weekLineChart.queue_draw();
      return true;
    });

    Gtk.Box chartBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

    chartBox.pack_start (hourLineChart);
    chartBox.pack_start (new Gtk.Label (_("Minute")), false, false, 0);
    chartBox.pack_start (dayLineChart);
    chartBox.pack_start (new Gtk.Label (_("Day")), false, false, 0);
    chartBox.pack_start (weekLineChart);
    chartBox.pack_start (new Gtk.Label (_("Week")), false, false, 0);
    chartBox.get_style_context().add_class("area");

    Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
    scrolled.set_min_content_width((int)(this.windowWidth/1.7));
    scrolled.set_min_content_height((int)this.windowHeight/3);
    scrolled.add(chartBox);
    scrolled.get_style_context().add_class("area");

    Gtk.Grid coinGrid = new Gtk.Grid ();
    coinGrid.orientation = Gtk.Orientation.HORIZONTAL;
    coinGrid.attach(scrolled,0,0,3,1);
    coinGrid.attach(verticalBoxSecondary, 3,0,1,1);
    coinGrid.get_style_context().add_class("box");
    coinGrid.set_row_homogeneous(true);
    coinGrid.set_column_homogeneous(true);

    Gtk.Label title = new Gtk.Label (coinAbrv);
    this.notebook.insert_page (coinGrid, title,1);
    this.notebook.show_all();

    var settings = new GLib.Settings ("com.github.dcharles525.crypt");
    int refreshRate = 0;
    settings.get ("refresh-rate", "i", out refreshRate);

    Timeout.add (refreshRate * 1000, () => {

      this.spinner.active = true;

      this.currentCoin.getCoinInfoFull(coinAbrv);

      priceTitle.label = coinAbrv
      .concat(": ",this.currentCoin.price.to_string()," | ",this.currentCoin.change24Hour.to_string(),
      " | ",this.currentCoin.changeP24Hour.to_string());
      priceTitle.xalign = 0;
      price.label = _("Price: ") + this.currentCoin.price;
      lastUpdate.label = _("Last Update: ") + this.currentCoin.lastUpdate;
      lastVolume.label = _("Last Volume: ") + this.currentCoin.lastVolume;
      lastVolumeTo.label = _("Last Volume To: ") + this.currentCoin.lastVolumeTo;
      lastTradeID.label = _("Last TradeID: ") + this.currentCoin.lastTradeID;
      volumeDay.label = _("Volume Day: ") + this.currentCoin.volumeDay;
      volumeDayTo.label = _("Volume Day To: ") + this.currentCoin.volumeDayTo;
      volume24Hour.label = _("Volume 24 Hour: ") + this.currentCoin.volume24Hour;
      volume24HourTo.label = _("Volume 24 Hour To: ") + this.currentCoin.volume24HourTo;
      openDay.label = _("Open Day: ") + this.currentCoin.openDay;
      highDay.label = _("Open High Day: ") + this.currentCoin.highDay;
      lowDay.label = _("Open Low Day: ") + this.currentCoin.lowDay;
      open24Hour.label = _("Open 24h: ") + this.currentCoin.open24Hour;
      high24Hour.label = _("Open High 24h: ") + this.currentCoin.high24Hour;
      low24Hour.label = _("Open Low 24h: ") + this.currentCoin.low24Hour;
      lastMarket.label = _("Last Market: ") + this.currentCoin.lastMarket;
      change24Hour.label = _("Change Last 24h: ") + this.currentCoin.change24Hour;
      changeP24Hour.label = _("Change Percent Last 24h: ") + this.currentCoin.changeP24Hour;
      changeDay.label = _("Change Day: ") + this.currentCoin.changeDay;
      changePDay.label = _("Change Percent Day: ") + this.currentCoin.changePDay;
      supply.label = _("Supply: ") + this.currentCoin.supply;
      mCap.label = _("Market Cap: ") + this.currentCoin.mCap;
      totalVolume24Hour.label = _("Total Volume 24h: ") + this.currentCoin.totalVolume24Hour;
      totalVolume24HTo.label = _("Total Volume 24h To: ") + this.currentCoin.totalVolume24HTo;

      currentCoin.getPriceDataHour(coinAbrv);

      hourLineChart.DATA = currentCoin.DATA;
      hourLineChart.HIGH = currentCoin.HIGH;
      hourLineChart.LOW = currentCoin.LOW;
      hourLineChart.calculations();

      currentCoin.getPriceDataDay(coinAbrv);

      dayLineChart.DATA = currentCoin.DATA;
      dayLineChart.HIGH = currentCoin.HIGH;
      dayLineChart.LOW = currentCoin.LOW;
      dayLineChart.calculations();

      currentCoin.getPriceDataWeek(coinAbrv);

      weekLineChart.DATA = currentCoin.DATA;
      weekLineChart.HIGH = currentCoin.HIGH;
      weekLineChart.LOW = currentCoin.LOW;
      weekLineChart.calculations();

      this.notebook.show_all();
      this.spinner.active = false;

      return true;

    });

    this.spinner.active = false;

  }

  public void getMainPageCoins(){

    MainLoop loop = new MainLoop ();

    Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,BCH,LTC,ETH&tsyms=".concat(this.defaultCoin));

    session.queue_message (message, (sess, message) => {

		  try {

			  var parser = new Json.Parser ();
        parser.load_from_data((string) message.response_body.flatten().data, -1);
        var root_object = parser.get_root ().get_object ();
        var btcData = root_object.get_object_member ("DISPLAY").get_object_member("BTC").get_object_member(this.defaultCoin);
        var bchData = root_object.get_object_member ("DISPLAY").get_object_member("BCH").get_object_member(this.defaultCoin);
        var ltcData = root_object.get_object_member ("DISPLAY").get_object_member("LTC").get_object_member(this.defaultCoin);
        var ethData = root_object.get_object_member ("DISPLAY").get_object_member("ETH").get_object_member(this.defaultCoin);

        Gtk.Label pricesHomeLabel = new Gtk.Label (_("Current Coin Prices"));
        pricesHomeLabel.get_style_context().add_class("title-text");
        pricesHomeLabel.get_style_context().add_class("padding-top");

        Gtk.Box verticalGridBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        verticalGridBox.get_style_context().add_class("area");
        verticalGridBox.set_spacing(10);
        verticalGridBox.pack_start(pricesHomeLabel);

        string btcPrice = btcData.get_string_member("PRICE");
        string btcHigh = btcData.get_string_member("HIGH24HOUR");
        string btcLow = btcData.get_string_member("LOW24HOUR");
        int64 btcTime = btcData.get_int_member("LASTUPDATE");
        DateTime btcTimeObject = new DateTime.from_unix_utc (btcTime);

        Gtk.Label btcLabel = new Gtk.Label ("Bitcoin");

        Gtk.Label btcPriceLabel;

        if (btcPrice.length > 5){

          btcPriceLabel = new Gtk.Label (_(" Current: ").concat(btcPrice));

        }else{

          btcPriceLabel = new Gtk.Label (_(" Current: Unavailable"));

        }

        Gtk.Label btcHighLabel;

        if (btcHigh.length > 5){

          btcHighLabel = new Gtk.Label (_(" | High: ").concat(btcHigh));

        }else{

          btcHighLabel = new Gtk.Label (_(" | High: Unavailable"));

        }

        Gtk.Label btcLowLabel;

        if (btcLow.length > 5){

          btcLowLabel = new Gtk.Label (_(" | Low: ").concat(btcLow));

        }else{

          btcLowLabel = new Gtk.Label (_(" | Low: Unavailable"));

        }

        Gtk.Label btcDateLabel = new Gtk.Label (_("Last Update: ").concat(btcTimeObject.to_string()));
        btcLabel.get_style_context().add_class("large-text");
        btcPriceLabel.get_style_context().add_class("price-blue-text");
        btcHighLabel.get_style_context().add_class("price-text");
        btcLowLabel.get_style_context().add_class("price-red-text");
        btcLabel.set_alignment(0,0);
        btcDateLabel.set_alignment(0,0);

        var btcGrid = new Gtk.Grid ();
        btcGrid.orientation = Gtk.Orientation.HORIZONTAL;
        btcGrid.attach (btcLabel,      0, 0, 1, 1);
        btcGrid.attach (btcPriceLabel, 1, 0, 1, 1);
        btcGrid.attach (btcHighLabel,  2, 0, 1, 1);
        btcGrid.attach (btcLowLabel,   3, 0, 1, 1);
        btcGrid.attach (btcDateLabel,  0, 1, 1, 1);

        verticalGridBox.pack_start(btcGrid,false,false);
        verticalGridBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

        string bchPrice = bchData.get_string_member("PRICE");
        string bchHigh = bchData.get_string_member("HIGH24HOUR");
        string bchLow = bchData.get_string_member("LOW24HOUR");
        int64 bchTime = bchData.get_int_member("LASTUPDATE");
        DateTime bchTimeObject = new DateTime.from_unix_utc (bchTime);

        Gtk.Label bchLabel = new Gtk.Label (_("Bitcoin Cash"));

        Gtk.Label bchPriceLabel;

        if (bchPrice.length > 4){

          bchPriceLabel = new Gtk.Label (_(" Current: ").concat(bchPrice));

        }else{

          bchPriceLabel = new Gtk.Label (_(" Current: Unavailable"));

        }

        Gtk.Label bchHighLabel;

        if (bchHigh.length > 4){

          bchHighLabel = new Gtk.Label (_(" | High: ").concat(bchHigh));

        }else{

          bchHighLabel = new Gtk.Label (_(" | High: Unavailable"));

        }


        Gtk.Label bchLowLabel;

        if (bchLow.length > 4){

          bchLowLabel = new Gtk.Label (_(" | Low: ").concat(bchLow));

        }else{

          bchLowLabel = new Gtk.Label (_(" | Low: Unavailable"));

        }

        Gtk.Label bchDateLabel = new Gtk.Label (_("Last Update: ").concat(bchTimeObject.to_string()));
        bchLabel.get_style_context().add_class("large-text");
        bchPriceLabel.get_style_context().add_class("price-blue-text");
        bchHighLabel.get_style_context().add_class("price-text");
        bchLowLabel.get_style_context().add_class("price-red-text");
        bchLabel.set_alignment(0,0);
        bchDateLabel.set_alignment(0,0);

        var bchGrid = new Gtk.Grid ();
        bchGrid.orientation = Gtk.Orientation.HORIZONTAL;
        bchGrid.attach (bchLabel,      0, 0, 1, 1);
        bchGrid.attach (bchPriceLabel, 1, 0, 1, 1);
        bchGrid.attach (bchHighLabel,  2, 0, 1, 1);
        bchGrid.attach (bchLowLabel,   3, 0, 1, 1);
        bchGrid.attach (bchDateLabel,  0, 1, 1, 1);
        bchGrid.get_style_context().add_class("off-row-color");

        verticalGridBox.pack_start(bchGrid,false,false);
        verticalGridBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

        string ltcPrice = ltcData.get_string_member("PRICE");
        string ltcHigh = ltcData.get_string_member("HIGH24HOUR");
        string ltcLow = ltcData.get_string_member("LOW24HOUR");
        int64 ltcTime = ltcData.get_int_member("LASTUPDATE");
        DateTime ltcTimeObject = new DateTime.from_unix_utc ((int64)ltcTime);

        Gtk.Label ltcLabel = new Gtk.Label (_("Litecoin"));

        Gtk.Label ltcPriceLabel;

        if (ltcPrice.length > 3){

          ltcPriceLabel = new Gtk.Label (_(" Current: ").concat(ltcPrice));

        }else{

          ltcPriceLabel = new Gtk.Label (_(" Current: Unavailable"));

        }

        Gtk.Label ltcHighLabel;

        if (ltcHigh.length > 3){

          ltcHighLabel = new Gtk.Label (_(" | High: ").concat(ltcHigh));

        }else{

          ltcHighLabel = new Gtk.Label (_(" | High: Unavailable"));

        }

        Gtk.Label ltcLowLabel;

        if (ltcLow.length > 3){

          ltcLowLabel = new Gtk.Label (_(" | Low: ").concat(ltcLow));

        }else{

          ltcLowLabel = new Gtk.Label (_(" | Low: Unavailable"));

        }

        Gtk.Label ltcDateLabel = new Gtk.Label (_("Last Update: ").concat(ltcTimeObject.to_string()));
        ltcLabel.get_style_context().add_class("large-text");
        ltcPriceLabel.get_style_context().add_class("price-blue-text");
        ltcHighLabel.get_style_context().add_class("price-text");
        ltcLowLabel.get_style_context().add_class("price-red-text");
        ltcLabel.set_alignment(0,0);
        ltcDateLabel.set_alignment(0,0);

        var ltcGrid = new Gtk.Grid ();
        ltcGrid.orientation = Gtk.Orientation.HORIZONTAL;
        ltcGrid.attach (ltcLabel,      0, 0, 1, 1);
        ltcGrid.attach (ltcPriceLabel, 1, 0, 1, 1);
        ltcGrid.attach (ltcHighLabel,  2, 0, 1, 1);
        ltcGrid.attach (ltcLowLabel,   3, 0, 1, 1);
        ltcGrid.attach (ltcDateLabel,  0, 1, 1, 1);

        verticalGridBox.pack_start(ltcGrid,false,false);
        verticalGridBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

        string ethPrice = ethData.get_string_member("PRICE");
        string ethHigh = ethData.get_string_member("HIGH24HOUR");
        string ethLow = ethData.get_string_member("LOW24HOUR");
        int64 ethTime = ethData.get_int_member("LASTUPDATE");
        DateTime ethTimeObject = new DateTime.from_unix_utc ((int64)ethTime);

        Gtk.Label ethLabel = new Gtk.Label (_("Etherum"));

        Gtk.Label ethPriceLabel;

        if (ethPrice.length > 5){

          ethPriceLabel = new Gtk.Label (_(" Current: ").concat(ethPrice));

        }else{

          ethPriceLabel = new Gtk.Label (_(" Current: Unavailable"));

        }

        Gtk.Label ethHighLabel;

        if (ethHigh.length > 5){

          ethHighLabel = new Gtk.Label (_(" | High: ").concat(ethHigh));

        }else{

          ethHighLabel = new Gtk.Label (_(" | High: Unavailable"));

        }


        Gtk.Label ethLowLabel;

        if (ethLow.length > 5){

          ethLowLabel = new Gtk.Label (_(" | Low: ").concat(ethLow));

        }else{

          ethLowLabel = new Gtk.Label (_(" | Low: Unavailable"));

        }

        Gtk.Label ethDateLabel = new Gtk.Label (_("Last Update: ").concat(ethTimeObject.to_string()));
        ethLabel.get_style_context().add_class("large-text");
        ethPriceLabel.get_style_context().add_class("price-blue-text");
        ethHighLabel.get_style_context().add_class("price-text");
        ethLowLabel.get_style_context().add_class("price-red-text");
        ethLabel.set_alignment(0,0);
        ethDateLabel.set_alignment(0,0);

        var ethGrid = new Gtk.Grid ();
        ethGrid.orientation = Gtk.Orientation.HORIZONTAL;
        ethGrid.attach (ethLabel,      0, 0, 1, 1);
        ethGrid.attach (ethPriceLabel, 1, 0, 1, 1);
        ethGrid.attach (ethHighLabel,  2, 0, 1, 1);
        ethGrid.attach (ethLowLabel,   3, 0, 1, 1);
        ethGrid.attach (ethDateLabel,  0, 1, 1, 1);
        ethGrid.get_style_context().add_class("off-row-color");

        verticalGridBox.pack_start(ethGrid,false,false);
        verticalGridBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

        this.secondaryBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        this.secondaryBox.pack_start(verticalGridBox,false,false);

      }catch (Error e) {

        stderr.printf (_("Something is wrong in getMainPageCoins"));

      }

      loop.quit();

    });

    loop.run();

  }

  public void getNewsMainPage(){

    Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/v2/news/?lang=EN");
		session.send_message (message);
    Gtk.Box newsBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    newsBox.set_spacing(10);
    Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);

    Gtk.Label currentNewsLabel = new Gtk.Label (_("Current News"));
    currentNewsLabel.get_style_context().add_class("title-text");
    currentNewsLabel.get_style_context().add_class("padding-top");

    newsBox.pack_start(currentNewsLabel);

		try {

			var parser = new Json.Parser ();
      parser.load_from_data((string) message.response_body.flatten().data, -1);
      var root_object = parser.get_root ().get_object ();
      var response = root_object.get_array_member("Data");

      foreach (var news in response.get_elements()) {

        var newsObject = news.get_object();

        Gtk.Label titleLabel = new Gtk.Label (newsObject.get_string_member("title"));
        Gtk.Label linkLabel = new Gtk.Label (newsObject.get_string_member("url"));
        linkLabel.set_markup("<a href='".concat(newsObject.get_string_member("url"),"'>",newsObject.get_string_member("url"),"</a>"));
        titleLabel.set_alignment(0,0);
        titleLabel.set_line_wrap(true);
        titleLabel.set_line_wrap_mode(Pango.WrapMode.WORD_CHAR);
        titleLabel.set_max_width_chars(100);
        linkLabel.set_alignment(0,0);
        linkLabel.set_use_markup(true);
        linkLabel.set_line_wrap(true);
        linkLabel.set_selectable(true);
        linkLabel.set_line_wrap_mode(Pango.WrapMode.WORD_CHAR);
        linkLabel.set_max_width_chars(100);

        newsBox.get_style_context().add_class("area");
        newsBox.pack_start(titleLabel);
        newsBox.pack_start(linkLabel);
        newsBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

      }

    }catch (Error e) {

      stderr.printf (_("Something is wrong in getNewsMainPage"));

    }

    scrolled.set_max_content_width(200);
    scrolled.set_min_content_height(540);
    scrolled.add(newsBox);

    this.secondaryBox.pack_end(scrolled);

  }

}

int main (string[] args){
  Gtk.init (ref args);

  Crypt crypt = new Crypt();
  Draw drawClass = new Draw();

  try {

    crypt.provider.load_from_data (crypt.CODE_STYLE, crypt.CODE_STYLE.length);
    Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), crypt.provider,
    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

  } catch (Error e) {

    warning("css didn't load %s",e.message);

  }

  Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);

  var settings = new GLib.Settings ("com.github.dcharles525.crypt");
  crypt.defaultCoin = settings.get_value("main-coin").get_string();
  int refreshRate = 0;
  settings.get ("refresh-rate", "i", out refreshRate);

  crypt.spinner.active = true;
  crypt.windowWidth = 1200;

  var windowTitle = "Crypt";
  crypt.window.title = windowTitle;
  crypt.window.set_default_size (1300,600);
  crypt.window.set_position (Gtk.WindowPosition.CENTER);
  Gtk.Label title = new Gtk.Label (_("Home"));

  Gtk.Label btcLabel = new Gtk.Label (_("Bitcoin (BTC)"));
  Gtk.Label ltcLabel = new Gtk.Label (_("Litecoin (LTC)"));
  Gtk.Label ethLabel = new Gtk.Label (_("Etherum (ETH)"));

  Caroline btcLineChart = drawClass.drawSmallChartHour("BTC",((int)crypt.windowWidth) - 50,(int)(crypt.windowHeight/3) - 50);
  Caroline ltcLineChart = drawClass.drawSmallChartHour("LTC",((int)crypt.windowWidth) - 50,(int)(crypt.windowHeight/3) - 50);
  Caroline ethLineChart = drawClass.drawSmallChartHour("ETH",((int)crypt.windowWidth) - 50,(int)(crypt.windowHeight/3) - 50);

  Timeout.add(500,()=>{
    btcLineChart.queue_draw();
    ltcLineChart.queue_draw();
    ethLineChart.queue_draw();
    return true;
  });

  Gtk.Label chartHomeLabel = new Gtk.Label (_("Last Hour"));
  chartHomeLabel.get_style_context().add_class("title-text");

  Gtk.Box chartBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

  chartBox.pack_start (chartHomeLabel, false, false, 0);
  chartBox.pack_start (btcLineChart);
  chartBox.pack_start (btcLabel, false, false, 0);
  chartBox.pack_start (ltcLineChart);
  chartBox.pack_start (ltcLabel, false, false, 0);
  chartBox.pack_start (ethLineChart);
  chartBox.pack_start (ethLabel, false, false, 0);
  chartBox.get_style_context().add_class("area");

  crypt.getMainPageCoins();
  crypt.getNewsMainPage();

  crypt.mainGrid.orientation = Gtk.Orientation.HORIZONTAL;
  crypt.mainGrid.attach(chartBox,0,0,1,1);
  crypt.mainGrid.attach(crypt.secondaryBox, 1,0,1,1);
  crypt.mainGrid.get_style_context().add_class("box");
  crypt.mainGrid.set_row_homogeneous(true);
  crypt.mainGrid.set_column_homogeneous(true);

  Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
  scrolled.add(crypt.mainGrid);
  scrolled.set_max_content_width(1200);
  scrolled.set_min_content_height(700);

  crypt.notebook.insert_page (scrolled, title,0);

  crypt.getCoins();

  Gtk.Button addCoinButton = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
  addCoinButton.clicked.connect (() => {

    crypt.addCoinTab(crypt.comboBox.get_active_text());

  });

  Gtk.Image settingsImage = new Gtk.Image.from_icon_name ("preferences-system-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
  settingsImage.pixel_size = 16;
  Gtk.ToolButton settingsButton = new Gtk.ToolButton (settingsImage, null);
  settingsButton.clicked.connect (() => {

    settings = new GLib.Settings ("com.github.dcharles525.crypt");

    var entry = new Entry ();
    entry.set_text(settings.get_value("main-coin").get_string());

    Gtk.Label defaultCurrencyLabel = new Gtk.Label (_("Set Default Currency (Tested with USD,GBP,EUR)"));
    defaultCurrencyLabel.xalign = 0;

    Gtk.Label saveLabel = new Gtk.Label ("");
    defaultCurrencyLabel.xalign = 0;

    Gtk.Button saveButton = new Gtk.Button.with_label (_("Save"));
    saveButton.get_style_context().add_class("button-color");

    var refreshEntry = new Entry ();
    settings.get ("refresh-rate", "i", out refreshRate);
    refreshEntry.set_text(refreshRate.to_string());

    Gtk.Label refreshLabel = new Gtk.Label (_("Set the refresh rate (in seconds)"));
    refreshLabel.xalign = 0;

    Gtk.Label saveRefreshLabel = new Gtk.Label ("");
    saveRefreshLabel.xalign = 0;

    Gtk.Button saveRefreshButton = new Gtk.Button.with_label (_("Save"));
    saveRefreshButton.get_style_context().add_class("button-color");

    Gtk.Dialog dialog = new Gtk.Dialog ();
    dialog.width_request = 500;
    dialog.get_content_area ().spacing = 7;
    dialog.get_content_area ().border_width = 10;
    dialog.get_content_area ().pack_start (defaultCurrencyLabel,false,false);
    dialog.get_content_area ().pack_start (entry,false,false);
    dialog.get_content_area ().pack_start (saveButton,false,false);
    dialog.get_content_area ().pack_start (saveLabel,false,false);
    dialog.get_content_area ().pack_start (refreshLabel,false,false);
    dialog.get_content_area ().pack_start (refreshEntry,false,false);
    dialog.get_content_area ().pack_start (saveRefreshButton,false,false);
    dialog.get_content_area ().pack_start (saveRefreshLabel,false,false);
    dialog.get_widget_for_response (Gtk.ResponseType.OK).can_default = true;
    dialog.set_default_response (Gtk.ResponseType.OK);
    dialog.show_all ();

    saveButton.clicked.connect (() => {

      crypt.defaultCoin = entry.get_text();
      settings.set_value("main-coin",entry.get_text());
      saveLabel.label = (_("Settings Saved! Restarting the app is recommended…"));

		});

    saveRefreshButton.clicked.connect (() => {

      refreshRate = refreshEntry.get_text().to_int();
      settings.set_value("refresh-rate",refreshRate);
      saveRefreshLabel.label = (_("Refresh rate saved! Restarting the app is recommended…"));

		});

  });

  var header = new Gtk.HeaderBar ();
  header.show_close_button = true;
  header.title = windowTitle;
  header.pack_start (crypt.comboBox);
  header.pack_start (addCoinButton);
  header.pack_end (settingsButton);
  header.pack_end (crypt.spinner);
  header.show_all();
  crypt.window.set_titlebar(header);
  crypt.window.add(crypt.notebook);
  crypt.window.show_all();
  crypt.window.destroy.connect(()=>{
    crypt.m.quit();
    Gtk.main_quit();
  });

  crypt.spinner.active = false;
  bool ctrBool = false;
  bool wBool = false;

  crypt.window.key_press_event.connect ((event) => {

    if (event.keyval == Gdk.Key.Control_L){

      ctrBool = true;

    }

    if (event.keyval == Gdk.Key.w){

      wBool = true;

    }

    if (ctrBool && wBool){

      int currentPage = crypt.notebook.get_current_page();

      if (currentPage != 0){

        crypt.notebook.remove_page(currentPage);

      }

      ctrBool = false;
      wBool = false;

    }

    return false;

  });

  Timeout.add (refreshRate * 1000, () => {

    crypt.spinner.active = true;

    crypt.currentCoinHour.getPriceDataHour("BTC");

    btcLineChart.DATA = crypt.currentCoinHour.DATA;
    btcLineChart.HIGH = crypt.currentCoinHour.HIGH;
    btcLineChart.LOW = crypt.currentCoinHour.LOW;
    btcLineChart.calculations();

    crypt.currentCoinHour.getPriceDataHour("LTC");

    ltcLineChart.DATA = crypt.currentCoinHour.DATA;
    ltcLineChart.HIGH = crypt.currentCoinHour.HIGH;
    ltcLineChart.LOW = crypt.currentCoinHour.LOW;
    ltcLineChart.calculations();

    crypt.currentCoinHour.getPriceDataHour("ETH");

    ethLineChart.DATA = crypt.currentCoinHour.DATA;
    ethLineChart.HIGH = crypt.currentCoinHour.HIGH;
    ethLineChart.LOW = crypt.currentCoinHour.LOW;
    ethLineChart.calculations();

    crypt.getMainPageCoins();
    crypt.getNewsMainPage();

    crypt.mainGrid.remove_column(1);
    crypt.mainGrid.attach(crypt.secondaryBox,1,0,1,1);
    crypt.notebook.show_all();
    crypt.spinner.active = false;

    return true;

  });

  Gtk.main();
  return 0;

}
