using Soup;
using Gtk;
using Json;
using WebKit;
using Gee;
using Cairo;

/*
- Split up code and condense it
*/

public class Crypt: Gtk.Application{

  public double windowWidth;
  public double windowHeight;
  public new Granite.Widgets.Toast toastNetwork = new Granite.Widgets.Toast (_("A coin is already loading, wait till that finishes!"));
  public Gtk.Window window = new Gtk.Window();
  public Gtk.Notebook notebook = new Gtk.Notebook();
  public Gtk.Notebook notebookSecondary = new Gtk.Notebook();
  public Gtk.Paned panelArea = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);
  public Caroline caroline = new Caroline();
  public Gtk.CssProvider provider = new Gtk.CssProvider();
  public Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
  public Gtk.Box secondaryBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
  public Gtk.Box deleteBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
  public Gtk.Grid chartGrid = new Gtk.Grid ();
  public Gtk.Grid mainGrid = new Gtk.Grid ();
  public Gtk.ListStore listModel = new Gtk.ListStore(8, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (Gtk.Button));
  public MainLoop m = new MainLoop();
  public Coin currentCoin = new Coin();
  public Coin currentCoinHour = new Coin();
  public Draw drawClass = new Draw();
  public Gtk.Spinner spinner = new Gtk.Spinner();
  public Gtk.TreeView mainAreaTreeView = new Gtk.TreeView();
  public int signalDampener = 0;
  public int signalDampenerSecondary = 0;
  public string defaultCoin = "";
  public bool networkAccess = false;
  public ArrayList<string> coinNames = new ArrayList<string>();
  public ArrayList<string> coinAbbrevs = new ArrayList<string>();
  public int refreshRate = 60;
  public int notificationValue = 1;
  private int firstRun = 0;
  public Caroline btcLineChart;
  public Caroline ltcLineChart;
  public Caroline ethLineChart;
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
      background-image: linear-gradient( #00aeae, #1aaeae);
    }

    .button-color-sell{
      background-image: linear-gradient( #ea221f, #ea3c1f);
    }

    .table{
      padding: 5px;
      border-bottom-color: #1d1d1d;
      border-bottom-style: solid;
      border-bottom-width: 1px;
    }
  """;

  public void addCoinTab(string coinAbrv){

    if (this.spinner.active != true){

      this.spinner.active = true;
      this.currentCoin.getCoinInfoFull(coinAbrv);
      this.windowHeight = 600;

      Gtk.Label priceTitle = new Gtk.Label (coinAbrv
      .concat(": ",this.currentCoin.price.to_string()," | ",this.currentCoin.change24Hour.to_string(),
      " | ",this.currentCoin.changeP24Hour.to_string()));
      priceTitle.get_style_context().add_class("title-text");
      priceTitle.get_style_context().add_class("padding-top");
      Gtk.Label price = new Gtk.Label (_("Price: ") + this.currentCoin.price);
      Gtk.Label lastUpdate = new Gtk.Label (_("Last Update: ") + this.currentCoin.lastUpdate);
      Gtk.Label lastVolume = new Gtk.Label (_("Last Volume: ") + this.currentCoin.lastVolume);
      Gtk.Label lastVolumeTo = new Gtk.Label (_("Last Volume To: ") + this.currentCoin.lastVolumeTo);
      Gtk.Label lastTradeID = new Gtk.Label (_("Last TradeID: ") + this.currentCoin.lastTradeID);
      Gtk.Label volumeDay = new Gtk.Label (_("Volume Day: ") + this.currentCoin.volumeDay);
      Gtk.Label volumeDayTo = new Gtk.Label (_("Volume Day To: ") + this.currentCoin.volumeDayTo);
      Gtk.Label volume24Hour = new Gtk.Label (_("Volume 24 Hour: ") + this.currentCoin.volume24Hour);
      Gtk.Label volume24HourTo = new Gtk.Label (_("Volume 24 Hour To: ") + this.currentCoin.volume24HourTo);
      Gtk.Label openDay = new Gtk.Label (_("Open Day: ") + this.currentCoin.openDay);
      Gtk.Label highDay = new Gtk.Label (_("Open High Day: ") + this.currentCoin.highDay);
      Gtk.Label lowDay = new Gtk.Label (_("Open Low Day: ") + this.currentCoin.lowDay);
      Gtk.Label open24Hour = new Gtk.Label (_("Open 24h: ") + this.currentCoin.open24Hour);
      Gtk.Label high24Hour = new Gtk.Label (_("Open High 24h: ") + this.currentCoin.high24Hour);
      Gtk.Label low24Hour = new Gtk.Label (_("Open Low 24h: ") + this.currentCoin.high24Hour);
      Gtk.Label lastMarket = new Gtk.Label (_("Last Market: ") + this.currentCoin.lastMarket);
      Gtk.Label change24Hour = new Gtk.Label (_("Change Last 24h: ") + this.currentCoin.change24Hour);
      Gtk.Label changeP24Hour = new Gtk.Label (_("Change Percent Last 24h: ") + this.currentCoin.changeP24Hour);
      Gtk.Label changeDay = new Gtk.Label (_("Change Day: ") + this.currentCoin.changeDay);
      Gtk.Label changePDay = new Gtk.Label (_("Change Percent Day: ") + this.currentCoin.changePDay);
      Gtk.Label supply = new Gtk.Label (_("Supply: ") + this.currentCoin.supply);
      Gtk.Label mCap = new Gtk.Label (_("Market Cap: ") + this.currentCoin.mCap);
      Gtk.Label totalVolume24Hour = new Gtk.Label (_("Total Volume 24h: ") + this.currentCoin.totalVolume24Hour);
      Gtk.Label totalVolume24HTo = new Gtk.Label (_("Total Volume 24h To: ") + this.currentCoin.totalVolume24HTo);
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

      Gtk.Label currentNewsLabel = new Gtk.Label ((_("Current News")) + " (" + coinAbrv + ")");
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
          var url = newsObject.get_string_member("url");
          url = url.replace ("&", "amp;");
          Gtk.Label titleLabel = new Gtk.Label (newsObject.get_string_member("title"));
          Gtk.Label linkLabel = new Gtk.Label (url);
          linkLabel.set_markup("<a href='".concat(url,"'>",url,"</a>"));
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

        stderr.printf ("Something is wrong in getNewsMainPage");

        this.networkAccess = false;
        this.window.remove (this.deleteBox);
        this.window.remove (this.notebook);
        this.deleteBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        var welcome = new Granite.Widgets.Welcome (_("Whoops!"), _("Looks like you're not connected to a network, after connecting the app will refresh (based on your refresh rate)!"));
        this.deleteBox.pack_start(welcome);
        this.window.add(this.deleteBox);
        this.window.show_all();

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

      Timeout.add (this.refreshRate * 1000, () => {

        this.spinner.active = true;

        Coin tempCoinObject = new Coin();
        tempCoinObject.getCoinInfoFull(coinAbrv);

        priceTitle.label = coinAbrv
        .concat(": ",tempCoinObject.price.to_string()," | ",tempCoinObject.changeDay.to_string(),
        " | ",tempCoinObject.changePDay.to_string());
        priceTitle.xalign = 0;
        price.label = (_("Price: ")) + tempCoinObject.price;
        lastUpdate.label = (_("Last Update: ")) + tempCoinObject.lastUpdate;
        lastVolume.label = (_("Last Volume: ")) + tempCoinObject.lastVolume;
        lastVolumeTo.label = (_("Last Volume To: ")) + tempCoinObject.lastVolumeTo;
        volumeDay.label = (_("Volume Day: ")) + tempCoinObject.volumeDay;
        lastTradeID.label = (_("Last TradeID: ")) + tempCoinObject.lastTradeID;
        volumeDayTo.label = (_("Volume Day To: ")) + tempCoinObject.volumeDayTo;
        volume24HourTo.label = (_("Volume 24 Hour To: ")) + tempCoinObject.volume24HourTo;
        volume24Hour.label = (_("Volume 24 Hour: ")) + tempCoinObject.volume24Hour;
        openDay.label = (_("Open Day: ")) + tempCoinObject.openDay;
        highDay.label = (_("Open High Day: ")) + tempCoinObject.highDay;
        lowDay.label = (_("Open Low Day: ")) + tempCoinObject.lowDay;
        open24Hour.label = (_("Open 24h: ")) + tempCoinObject.open24Hour;
        high24Hour.label = (_("Open High 24h: ")) + tempCoinObject.high24Hour;
        low24Hour.label = (_("Open Low 24h: ")) + tempCoinObject.low24Hour;
        lastMarket.label = (_("Last Market: ")) + tempCoinObject.lastMarket;
        change24Hour.label = (_("Change Last 24h: ")) + tempCoinObject.change24Hour;
        changeP24Hour.label = (_("Change Percent Last 24h: ")) + tempCoinObject.changeP24Hour;
        changeDay.label = (_("Change Day: ")) + tempCoinObject.changeDay;
        changePDay.label = (_("Change Percent Day: ")) + tempCoinObject.changePDay;
        supply.label = (_("Supply: ")) + tempCoinObject.supply;
        mCap.label = (_("Market Cap: ")) + tempCoinObject.mCap;
        totalVolume24Hour.label = (_("Total Volume 24h: ")) + tempCoinObject.totalVolume24Hour;
        totalVolume24HTo.label = (_("Total Volume 24h To: ")) + tempCoinObject.totalVolume24HTo;

        tempCoinObject.getPriceDataHour(coinAbrv);

        hourLineChart.DATA = tempCoinObject.DATA;
        hourLineChart.HIGH = tempCoinObject.HIGH;
        hourLineChart.LOW = tempCoinObject.LOW;
        hourLineChart.calculations();

        tempCoinObject.getPriceDataDay(coinAbrv);

        dayLineChart.DATA = tempCoinObject.DATA;
        dayLineChart.HIGH = tempCoinObject.HIGH;
        dayLineChart.LOW = tempCoinObject.LOW;
        dayLineChart.calculations();

        tempCoinObject.getPriceDataWeek(coinAbrv);

        weekLineChart.DATA = tempCoinObject.DATA;
        weekLineChart.HIGH = tempCoinObject.HIGH;
        weekLineChart.LOW = tempCoinObject.LOW;
        weekLineChart.calculations();

        this.notebook.show_all();
        this.spinner.active = false;

        return true;

      });

      this.spinner.active = false;

    }else{

      this.toastNetwork.send_notification ();

    }

  }

  public void getMainPageCoins(){

    this.coinNames.clear();
    this.coinAbbrevs.clear();

    Database dbObject = new Database();
    dbObject.createCheckDirectory();
    CoinList coinList = dbObject.getCoins();

    for (int i = 0; i < coinList.coinIds.size; i++){

      this.coinNames.add(coinList.coinNames.get(i));
      this.coinAbbrevs.add(coinList.coinAbbrvs.get(i));

    }

    Gtk.Box verticalGridBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    verticalGridBox.get_style_context().add_class("area");
    verticalGridBox.set_spacing(10);
    Gtk.Label pricesLabel = new Gtk.Label (_("Quick Price Lookup"));
    pricesLabel.get_style_context().add_class("title-text");
    verticalGridBox.pack_start(pricesLabel);

    this.mainAreaTreeView.button_press_event.connect ((event) => {

      if (event.type == Gdk.EventType.BUTTON_PRESS && event.button == 3) {

        TreePath path; TreeViewColumn column; int cell_x; int cell_y;
				this.mainAreaTreeView.get_path_at_pos ((int)event.x, (int)event.y, out path, out column, out cell_x, out cell_y);
				this.mainAreaTreeView.grab_focus();
     		this.mainAreaTreeView.set_cursor(path,column,false);

				TreeSelection aTreeSelection = this.mainAreaTreeView.get_selection ();

        if(aTreeSelection.count_selected_rows() == 1){

          Gtk.Menu menu = new Gtk.Menu ();

          Gtk.MenuItem menuItem = new Gtk.MenuItem.with_label (_("Set Limit Notifications"));
          menu.attach_to_widget (this.mainAreaTreeView, null);
          menu.add (menuItem);
          menuItem.activate.connect((e) => {
            this.openLimitDialog(event);
          });

          menuItem = new Gtk.MenuItem.with_label (_("Open Detailed Info"));
          menu.add (menuItem);
          menuItem.activate.connect((e) => {
            this.openCoin(event);
          });

          menuItem = new Gtk.MenuItem.with_label (_("Delete"));
          menu.add (menuItem);
          menuItem.activate.connect((e) => {
            this.deleteCoin(event);
          });

          menu.show_all ();
          menu.popup (null, null, null, event.button, event.time);

        }

        return true;

      }

      return false;

    });

    this.mainAreaTreeView.activate_on_single_click = true;
    this.mainAreaTreeView.get_style_context().add_class("table");

    this.listModel = new Gtk.ListStore (8, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
    this.mainAreaTreeView.set_model (listModel);

    var text = new CellRendererText ();

    if (this.firstRun == 0){

      var coinColumn = new Gtk.TreeViewColumn ();
      coinColumn.set_title (_("Coin"));
      coinColumn.max_width = -1;
      coinColumn.min_width = 100;
      coinColumn.pack_start (text, false);
      coinColumn.resizable = true;
      coinColumn.reorderable = true;
      coinColumn.sort_column_id = 0;
      coinColumn.set_attributes ( text, "text", 0);
      coinColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

      this.mainAreaTreeView.append_column(coinColumn);

      var currentText = new CellRendererText ();

      var currentColumn = new Gtk.TreeViewColumn ();
      currentColumn.set_title (_("Current"));
      currentColumn.max_width = -1;
      currentColumn.min_width = 100;
      currentColumn.pack_start (currentText, false);
      currentColumn.resizable = true;
      currentColumn.reorderable = true;
      currentColumn.sort_column_id = 0;
      currentColumn.set_attributes (currentText, "text", 1);
      currentColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

      this.mainAreaTreeView.append_column(currentColumn);

      var highText = new CellRendererText ();

      var highColumn = new Gtk.TreeViewColumn ();
      highColumn.set_title (_("High"));
      highColumn.max_width = -1;
      highColumn.min_width = 100;
      highColumn.pack_start (highText, false);
      highColumn.resizable = true;
      highColumn.reorderable = true;
      highColumn.sort_column_id = 0;
      highColumn.set_attributes (highText, "text", 2);
      highColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

      this.mainAreaTreeView.append_column(highColumn);

      var lowText = new CellRendererText ();

      var lowColumn = new Gtk.TreeViewColumn ();
      lowColumn.set_title (_("Low"));
      lowColumn.max_width = -1;
      lowColumn.min_width = 100;
      lowColumn.pack_start (lowText, false);
      lowColumn.resizable = true;
      lowColumn.reorderable = true;
      lowColumn.sort_column_id = 0;
      lowColumn.set_attributes (lowText, "text", 3);
      lowColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

      this.mainAreaTreeView.append_column(lowColumn);

      var changeText = new CellRendererText ();

      var changeColumn = new Gtk.TreeViewColumn ();
      changeColumn.set_title (_("Change Price (DAY)"));
      changeColumn.max_width = -1;
      changeColumn.min_width = 100;
      changeColumn.pack_start (changeText, false);
      changeColumn.resizable = true;
      changeColumn.reorderable = true;
      changeColumn.sort_column_id = 0;
      changeColumn.set_attributes (changeText, "text", 4);
      changeColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

      this.mainAreaTreeView.append_column(changeColumn);

      var changePText = new CellRendererText ();

      var changePColumn = new Gtk.TreeViewColumn ();
      changePColumn.set_title (_("Change % (DAY)"));
      changePColumn.max_width = -1;
      changePColumn.min_width = 75;
      changePColumn.pack_start (changePText, false);
      changePColumn.resizable = true;
      changePColumn.reorderable = true;
      changePColumn.sort_column_id = 0;
      changePColumn.set_attributes (changePText, "text", 5);
      changePColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

      this.mainAreaTreeView.append_column(changePColumn);

      var lastExchange = new CellRendererText ();

      var lastExchangeColumn = new Gtk.TreeViewColumn ();
      lastExchangeColumn.set_title (_("Last Market"));
      lastExchangeColumn.max_width = -1;
      lastExchangeColumn.min_width = 100;
      lastExchangeColumn.pack_start (lastExchange, false);
      lastExchangeColumn.resizable = true;
      lastExchangeColumn.reorderable = true;
      lastExchangeColumn.sort_column_id = 0;
      lastExchangeColumn.set_attributes (lastExchange, "text", 6);
      lastExchangeColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

      this.mainAreaTreeView.append_column(lastExchangeColumn);

    }

    for (int i = 0; this.coinAbbrevs.size > i; i++){

      MainLoop loop = new MainLoop ();

      Soup.Session session = new Soup.Session();
  		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=".concat(this.coinAbbrevs.get(i),"&tsyms=",this.defaultCoin));

      session.queue_message (message, (sess, message) => {

        if (message.status_code == 200) {

    		  try {

    			  var parser = new Json.Parser ();
            parser.load_from_data((string) message.response_body.flatten().data, -1);
            var root_object = parser.get_root ().get_object ();
            var data = root_object.get_object_member ("DISPLAY").get_object_member(this.coinAbbrevs.get(i)).get_object_member(this.defaultCoin);
            var rawData = root_object.get_object_member ("RAW").get_object_member(this.coinAbbrevs.get(i)).get_object_member(this.defaultCoin);

            double rawPrice = rawData.get_double_member("PRICE");
            string price = data.get_string_member("PRICE");
            string high = data.get_string_member("HIGH24HOUR");
            string low = data.get_string_member("LOW24HOUR");
            string changeDay = data.get_string_member("CHANGEDAY");
            string changePDay = data.get_string_member("CHANGEPCTDAY");
            string lastMarket = data.get_string_member("LASTMARKET");

            if (this.notificationValue == 1){

              Database database = new Database();
              database.createCheckDirectory();
              CoinLimit coinLimit = database.getLimit(this.coinAbbrevs.get(i));

              for (int g = 0; coinLimit.coinIds.size > g; g++){

                if (coinLimit.coinEnabled.get(g) == 1){

                  if (rawPrice >= double.parse(coinLimit.coinHigh.get(g))){

                    var notification = new GLib.Notification (_("Limit Notification for ").concat(coinLimit.coinAbbrvs.get(g),(_("!"))));
                    notification.set_body ((coinLimit.coinAbbrvs.get(g).concat(_(" just hit "),coinLimit.coinHigh.get(g),(_("!")))));
                    this.send_notification ("com.github.dcharles525.crypt", notification);

                  }

                  if (rawPrice <= double.parse(coinLimit.coinLow.get(g))){

                    var notification = new GLib.Notification (_("Limit Notification for ").concat(coinLimit.coinAbbrvs.get(g),(_("!"))));
                    notification.set_body ((coinLimit.coinAbbrvs.get(g).concat(_(" just dropped to "),coinLimit.coinLow.get(g),(_("!")))));
                    this.send_notification ("com.github.dcharles525.crypt", notification);

                  }

                }

              }

            }

            TreeIter iter;
            this.listModel.append (out iter);
            this.listModel.set(iter, 0, this.coinNames.get(i), 1, price, 2, high, 3, low, 4, changeDay, 5, changePDay, 6, lastMarket);

          }catch (Error e) {

            stderr.printf ("Something is wrong in getMainPageCoins");

          }

        }

        loop.quit();

      });

      loop.run();

    }

    Gtk.ScrolledWindow scroll = new Gtk.ScrolledWindow (null, null);
    scroll.min_content_height = (int)(800 / 2);

    if (this.firstRun == 0){

      scroll.add (this.mainAreaTreeView);
      this.firstRun = 1;

    }

    scroll.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
    verticalGridBox.pack_start(scroll);
    this.secondaryBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    this.secondaryBox.pack_start(verticalGridBox,false,false);

  }

  public void openLimitDialog(Gdk.EventButton event){

    var selection = this.mainAreaTreeView.get_selection();
    selection.set_mode(SelectionMode.SINGLE);

    TreeModel model;
    TreeIter iter;

    if (selection.get_selected(out model, out iter)) {

      TreePath path = model.get_path(iter);
      int index = int.parse(path.to_string());

      string coinName = this.coinNames.get(index);
      string coinAbbrev = this.coinAbbrevs.get(index);

      Database database = new Database();
      database.createCheckDirectory();
      CoinLimit coinLimit = database.getLimit(coinAbbrev);

      Gtk.Label coinAbbrevLabel = new Gtk.Label(_("Limits for ").concat(coinName));
      coinAbbrevLabel.xalign = 0;
      coinAbbrevLabel.get_style_context().add_class("large-text");

      Gtk.Label highLabel = new Gtk.Label(_("High Limit"));
      highLabel.xalign = 0;
      Entry highLimitEntry = new Entry();
      Gtk.Label lowLabel = new Gtk.Label(_("Low Limit"));
      lowLabel.xalign = 0;
      Entry lowLimitEntry = new Entry();

      var modeSwitch = new Granite.ModeSwitch.from_icon_name ("notification-disabled-symbolic", "preferences-system-notifications-symbolic");
      modeSwitch.primary_icon_tooltip_text = (_("Notifications disabled for coin"));
      modeSwitch.secondary_icon_tooltip_text = (_("Notifications enabled for coin"));
      modeSwitch.valign = Gtk.Align.CENTER;

      if (coinLimit.coinIds.size > 0){

        if (coinLimit.coinEnabled.get(0) == 1){

          modeSwitch.active = true;

        }

        highLimitEntry.set_text(coinLimit.coinHigh.get(0));
        lowLimitEntry.set_text(coinLimit.coinLow.get(0));

      }

      Gtk.Button saveButton = new Gtk.Button.with_label(_("Save"));
      saveButton.get_style_context().add_class("button-color");

      Gtk.Dialog dialog = new Gtk.Dialog ();
      dialog.width_request = 500;
      dialog.get_content_area().spacing = 7;
      dialog.get_content_area().border_width = 10;
      dialog.get_content_area().pack_start(coinAbbrevLabel,false,false);
      dialog.get_content_area().pack_start(modeSwitch,false,false);
      dialog.get_content_area().pack_start(highLabel,false,false);
      dialog.get_content_area().pack_start(highLimitEntry,false,false);
      dialog.get_content_area().pack_start(lowLabel,false,false);
      dialog.get_content_area().pack_start(lowLimitEntry,false,false);
      dialog.get_content_area().pack_start(saveButton,false,false);
      dialog.get_widget_for_response(Gtk.ResponseType.OK).can_default = true;
      dialog.set_default_response(Gtk.ResponseType.OK);
      dialog.show_all();

      saveButton.clicked.connect (() => {

        database = new Database();
        database.createCheckDirectory();

        database.insertLimit(coinAbbrev,highLimitEntry.get_text(),lowLimitEntry.get_text(),modeSwitch.active);
        dialog.close();

      });

    }

  }

  public void openCoin(Gdk.EventButton event){

    var selection = this.mainAreaTreeView.get_selection();
    selection.set_mode(SelectionMode.SINGLE);

    TreeModel model;
    TreeIter iter;

    if (selection.get_selected(out model, out iter)) {

      TreePath path = model.get_path(iter);
      var index = int.parse(path.to_string());

      if (index >= 0) {

        this.addCoinTab(this.coinAbbrevs.get(index));

      }

    }

  }

  public void deleteCoin(Gdk.EventButton event){

    var selection = this.mainAreaTreeView.get_selection();
    selection.set_mode(SelectionMode.SINGLE);

    TreeModel model;
    TreeIter iter;
    TreeIter iterFinal;

    if (selection.get_selected(out model, out iter)){

      TreePath path = model.get_path(iter);
      var index = int.parse(path.to_string());

      if (index > 1) {

        Database dbObject = new Database();
        dbObject.createCheckDirectory();
        dbObject.deleteCoin(this.coinAbbrevs.get(index));
        model.get_iter(out iterFinal,path);
        this.listModel.remove(ref iterFinal);

        this.coinNames.clear();
        this.coinAbbrevs.clear();

        dbObject = new Database();
        dbObject.createCheckDirectory();
        CoinList coinList = dbObject.getCoins();

        for (int i = 0; i < coinList.coinIds.size; i++){

          this.coinNames.add(coinList.coinNames.get(i));
          this.coinAbbrevs.add(coinList.coinAbbrvs.get(i));

        }

      }

    }

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

      stderr.printf ("Something is wrong in getNewsMainPage");

    }

    scrolled.set_max_content_width(200);
    scrolled.set_min_content_height(540);
    scrolled.add(newsBox);

    this.secondaryBox.pack_end(scrolled);

  }

  public bool checkNetworkStatus(){

    try {

      var resolver = Resolver.get_default ();
      resolver.lookup_by_name ("www.elementary.io", null);

      return true;

    }catch (Error e) {

      try {

        var resolver = Resolver.get_default ();
        resolver.lookup_by_name ("www.duckduckgo.com", null);

        return true;

      }catch (Error e) {

        return false;

      }

    }

  }

  public void loadMainPage(){

    if (this.checkNetworkStatus()){

      this.networkAccess = true;

      var welcome = new Granite.Widgets.Welcome (_("Welcome to Crypt!"), _("Just downloading the latest data, this could take a second or two."));

      this.deleteBox.pack_start(welcome);
      this.window.add(this.deleteBox);
      this.window.show_all();

      Gtk.Label title = new Gtk.Label (_("Home"));

      Gtk.Label btcLabel = new Gtk.Label (_("Bitcoin (BTC)"));
      Gtk.Label ltcLabel = new Gtk.Label (_("Litecoin (LTC)"));
      Gtk.Label ethLabel = new Gtk.Label (_("Etherum (ETH)"));

      this.btcLineChart = drawClass.drawSmallChartHour("BTC",((int)this.windowWidth) - 50,(int)(this.windowHeight/3) - 50);
      this.ltcLineChart = drawClass.drawSmallChartHour("LTC",((int)this.windowWidth) - 50,(int)(this.windowHeight/3) - 50);
      this.ethLineChart = drawClass.drawSmallChartHour("ETH",((int)this.windowWidth) - 50,(int)(this.windowHeight/3) - 50);

      Timeout.add(500,()=>{
        btcLineChart.queue_draw();
        ltcLineChart.queue_draw();
        ethLineChart.queue_draw();
        return true;
      });

      var chart1ButtonGroup = new ChartButtonGroup().createButtonGroup("BTC",btcLineChart);
      var chart2ButtonGroup = new ChartButtonGroup().createButtonGroup("LTC",btcLineChart);
      var chart3ButtonGroup = new ChartButtonGroup().createButtonGroup("ETH",btcLineChart);

      Gtk.Box chartBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      chartBox.pack_start(btcLineChart);
      chartBox.pack_start(btcLabel, false, false, 0);
      //chartBox.pack_start(chart1ButtonGroup, false, false, 0);
      chartBox.pack_start(ltcLineChart);
      chartBox.pack_start(ltcLabel, false, false, 0);
      //chartBox.pack_start(chart2ButtonGroup, false, false, 0);
      chartBox.pack_start(ethLineChart);
      chartBox.pack_start(ethLabel, false, false, 0);
      //chartBox.pack_start(chart3ButtonGroup, false, false, 0);
      chartBox.get_style_context().add_class("area");

      this.panelArea = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);

      var width = 0;
      this.window.get_size(out width,null);
      this.panelArea.position = width / 2;
      this.window.configure_event.connect ((event) => {
        this.panelArea.position = event.width / 2;
        return false;
      });

      this.panelArea.add1(chartBox);

      this.getMainPageCoins();
      this.getNewsMainPage();

      this.panelArea.add2(this.secondaryBox);

      Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
      scrolled.add(this.panelArea);
      scrolled.set_max_content_width(1200);
      scrolled.set_min_content_height(500);

      this.notebook.insert_page (scrolled, title,0);

      Timeout.add (refreshRate * 1000, () => {

        if (this.checkNetworkStatus()){

          if (!this.networkAccess){

            this.notebook = this.notebookSecondary;
            this.window.remove (this.deleteBox);
            this.window.add(this.notebook);
            this.networkAccess = true;

          }

          this.spinner.active = true;
          //wrap in button states
          this.currentCoinHour.getPriceDataHour("BTC");

          btcLineChart.DATA = this.currentCoinHour.DATA;
          btcLineChart.HIGH = this.currentCoinHour.HIGH;
          btcLineChart.LOW = this.currentCoinHour.LOW;
          btcLineChart.calculations();

          this.currentCoinHour.getPriceDataHour("LTC");

          ltcLineChart.DATA = this.currentCoinHour.DATA;
          ltcLineChart.HIGH = this.currentCoinHour.HIGH;
          ltcLineChart.LOW = this.currentCoinHour.LOW;
          ltcLineChart.calculations();

          this.currentCoinHour.getPriceDataHour("ETH");

          ethLineChart.DATA = this.currentCoinHour.DATA;
          ethLineChart.HIGH = this.currentCoinHour.HIGH;
          ethLineChart.LOW = this.currentCoinHour.LOW;
          ethLineChart.calculations();

          this.getMainPageCoins();
          this.getNewsMainPage();

          this.mainGrid.remove_column(1);
          this.mainGrid.attach(this.secondaryBox,1,0,1,1);
          this.notebook.show_all();
          this.spinner.active = false;

        }else{

          this.notebookSecondary = this.notebook;

          this.networkAccess = false;
          this.window.remove (this.deleteBox);
          this.window.remove (this.notebook);
          this.deleteBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
          welcome = new Granite.Widgets.Welcome (_("Whoops!"), _("Looks like you're not connected to a network, after connecting the app will refresh (based on your refresh rate)!"));
          this.deleteBox.pack_start(welcome);
          this.window.add(this.deleteBox);
          this.window.show_all();

        }

        return true;

      });

      this.window.remove (this.deleteBox);
      this.window.add(this.notebook);
      this.window.show_all();

    }else{

      this.networkAccess = false;
      this.window.remove (this.deleteBox);
      this.window.remove (this.notebook);
      this.deleteBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      var welcome = new Granite.Widgets.Welcome (_("Whoops!"), _("Looks like you're not connected to a network, restart the app after reconnecting!"));
      this.window.add(welcome);
      this.window.show_all();

    }

    this.spinner.active = false;

  }

}

int main (string[] args){
  Gtk.init (ref args);

  //var indicator = new Indicator(); can't use this per the elementary guidelines
  Database database = new Database();
  Crypt crypt = new Crypt();

  crypt.set_application_id ("com.github.dcharles525.crypt") ;
  crypt.register();

  database.createCheckDirectory();

  try {

    crypt.provider.load_from_data (crypt.CODE_STYLE, crypt.CODE_STYLE.length);
    Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), crypt.provider,
    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

  } catch (Error e) {

    warning("css didn't load %s",e.message);

  }

  Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);

  GLib.Settings settings = new GLib.Settings ("com.github.dcharles525.crypt");

  if (settings != null){

    crypt.defaultCoin = settings.get_value("main-coin").get_string();
    crypt.refreshRate = 0;
    settings.get ("refresh-rate", "i", out crypt.refreshRate);

  }else{

    crypt.defaultCoin = "USD";
    crypt.refreshRate = 30;

  }

  crypt.spinner.active = true;
  Gtk.HeaderBar header = new Gtk.HeaderBar ();
  crypt.windowWidth = 1100;

  var windowTitle = _("Crypt");
  crypt.window.title = windowTitle;
  crypt.window.set_default_size (1200,600);
  crypt.window.set_position (Gtk.WindowPosition.CENTER);

  Gtk.Button addCoinButton = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
  addCoinButton.set_tooltip_markup(_("Add coin to global list"));
  addCoinButton.clicked.connect (() => {

    Gtk.Label addCoinLabel = new Gtk.Label (_("Add Coin"));
    addCoinLabel.xalign = 0;
    addCoinLabel.get_style_context().add_class("large-text");

    Gtk.Label coinNameLabel = new Gtk.Label (_("Coin Name"));
    coinNameLabel.xalign = 0;

    var coinNameEntry = new Entry ();

    Gtk.Label coinAbbrevLabel = new Gtk.Label (_("Coin Abbreviation"));
    coinAbbrevLabel.xalign = 0;

    Entry coinAbbrevEntry = new Entry ();

    Gtk.Button saveButton = new Gtk.Button.with_label (_("Save"));
    saveButton.get_style_context().add_class("button-color");

    Gtk.Label validCoinLabel = new Gtk.Label ("");
    validCoinLabel.xalign = 0;

    Gtk.Dialog dialog = new Gtk.Dialog ();
    dialog.width_request = 500;
    dialog.get_content_area ().spacing = 7;
    dialog.get_content_area ().border_width = 10;
    dialog.get_content_area ().pack_start (addCoinLabel,false,false);
    dialog.get_content_area ().pack_start (coinNameLabel,false,false);
    dialog.get_content_area ().pack_start (coinNameEntry,false,false);
    dialog.get_content_area ().pack_start (coinAbbrevLabel,false,false);
    dialog.get_content_area ().pack_start (coinAbbrevEntry,false,false);
    dialog.get_content_area ().pack_start (validCoinLabel,false,false);
    dialog.get_content_area ().pack_start (saveButton,false,false);
    dialog.get_widget_for_response (Gtk.ResponseType.OK).can_default = true;
    dialog.set_default_response (Gtk.ResponseType.OK);
    dialog.show_all ();

    saveButton.clicked.connect (() => {

      if (crypt.currentCoin.checkCoin(coinAbbrevEntry.get_text()) == 1){

        database = new Database();
        database.createCheckDirectory();
        database.insertCoin(coinNameEntry.get_text(),coinAbbrevEntry.get_text());
        dialog.close();

        TreeIter iter;
        crypt.listModel.append (out iter);
        crypt.listModel.set(iter, 0, coinNameEntry.get_text(), 1, _("Fetching Data"), 2, _("Fetching Data"), 3, _("Fetching Data"), 4, _("Fetching Data"), 5, _("Fetching Data"), 6, _("Fetching Data"));
        crypt.spinner.active = true;
        crypt.coinAbbrevs.add(coinAbbrevEntry.get_text());

      }else{

        validCoinLabel.label = (_("Whoops, that isn't a valid coin!"));

      }

    });

  });

  Gtk.Image settingsImage = new Gtk.Image.from_icon_name ("preferences-system-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
  settingsImage.pixel_size = 14;
  Gtk.ToolButton settingsButton = new Gtk.ToolButton (settingsImage, null);
  settingsButton.set_tooltip_markup(_("Preferences"));
  settingsButton.clicked.connect (() => {

    settings = new GLib.Settings ("com.github.dcharles525.crypt");

    if (settings != null){

      var entry = new Entry ();
      entry.set_text(settings.get_value("main-coin").get_string());

      Gtk.Label defaultCurrencyLabel = new Gtk.Label (_("Set Default Currency (Tested with USD,GBP,EUR)"));
      defaultCurrencyLabel.xalign = 0;

      Gtk.Label saveLabel = new Gtk.Label ("");
      defaultCurrencyLabel.xalign = 0;

      Gtk.Button saveButton = new Gtk.Button.with_label (_("Save"));
      saveButton.get_style_context().add_class("button-color");

      var refreshEntry = new Entry ();
      settings.get ("refresh-rate", "i", out crypt.refreshRate);
      refreshEntry.set_text(crypt.refreshRate.to_string());

      Gtk.Label refreshLabel = new Gtk.Label (_("Set the refresh rate (in seconds)"));
      refreshLabel.xalign = 0;

      Gtk.Label saveRefreshLabel = new Gtk.Label ("");
      saveRefreshLabel.xalign = 0;

      Gtk.Button saveRefreshButton = new Gtk.Button.with_label (_("Save"));
      saveRefreshButton.get_style_context().add_class("button-color");

      Gtk.Label settingsLabel = new Gtk.Label (_("Settings"));
      settingsLabel.xalign = 0;
      settingsLabel.get_style_context().add_class("title-text");

      Gtk.Dialog dialog = new Gtk.Dialog ();
      dialog.width_request = 500;
      dialog.get_content_area ().spacing = 7;
      dialog.get_content_area ().border_width = 10;
      dialog.get_content_area ().pack_start (settingsLabel,false,false);
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
        saveLabel.label = (_("Settings Saved! Restarting the app is recommended!"));

      });

      saveRefreshButton.clicked.connect (() => {

        crypt.refreshRate = int.parse(refreshEntry.get_text());
        settings.set_value("refresh-rate",crypt.refreshRate);
        saveRefreshLabel.label = (_("Refresh rate saved! Restarting the app is recommended!"));

      });

    }else{

      Gtk.Dialog dialog = new Gtk.Dialog ();
      dialog.width_request = 500;
      dialog.get_content_area ().spacing = 7;
      dialog.get_content_area ().border_width = 10;
      dialog.get_content_area ().pack_start (new Gtk.Label (_("Settings schema isn't installed properly, reinstall app.")),false,false);
      dialog.get_widget_for_response (Gtk.ResponseType.OK).can_default = true;
      dialog.set_default_response (Gtk.ResponseType.OK);
      dialog.show_all ();

    }

  });

  Gtk.Image walletImage = new Gtk.Image.from_icon_name ("payment-card-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
  walletImage.pixel_size = 14;

  settings = new GLib.Settings ("com.github.dcharles525.crypt");
  Gtk.Image notificationImage = new Gtk.Image.from_icon_name ("preferences-system-notifications-symbolic", Gtk.IconSize.SMALL_TOOLBAR);

  if (settings != null){

    settings.get("notifications", "i", out crypt.notificationValue);

    if (crypt.notificationValue == 1){

      notificationImage = new Gtk.Image.from_icon_name ("preferences-system-notifications-symbolic", Gtk.IconSize.SMALL_TOOLBAR);

    }else{

      notificationImage = new Gtk.Image.from_icon_name ("notification-disabled-symbolic", Gtk.IconSize.SMALL_TOOLBAR);

    }

  }

  notificationImage.pixel_size = 14;
  Gtk.ToolButton notificationButton = new Gtk.ToolButton (notificationImage, null);
  notificationButton.set_tooltip_markup(_("Global Notifications Toggle"));

  notificationButton.clicked.connect (() => {

    settings = new GLib.Settings ("com.github.dcharles525.crypt");

    if (settings != null){

      settings.get("notifications", "i", out crypt.notificationValue);

      if (crypt.notificationValue == 1){

        settings.set_value("notifications",0);
        notificationImage = new Gtk.Image.from_icon_name ("notification-disabled-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        notificationImage.pixel_size = 14;
        notificationButton.set_icon_widget(notificationImage);
        header.show_all();

        crypt.notificationValue = 0;

      }else{

        settings.set_value("notifications",1);
        notificationImage = new Gtk.Image.from_icon_name ("preferences-system-notifications-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        notificationImage.pixel_size = 14;
        notificationButton.set_icon_widget(notificationImage);
        header.show_all();

        crypt.notificationValue = 1;

      }

    }

  });

  Wallet wallet = new Wallet();
  crypt.notebook.append_page(wallet.buildTable(),new Gtk.Label (_("Wallet")));
  wallet.insertRows();
  Gtk.Label walletTotalLabel = new Gtk.Label(wallet.buildTotalText());

  header.show_close_button = true;
  header.title = windowTitle;
  header.pack_start (walletImage);
  header.pack_start (walletTotalLabel);
  header.pack_end (settingsButton);
  header.pack_end (notificationButton);
  header.pack_end (addCoinButton);
  header.pack_end (crypt.spinner);
  header.show_all();
  crypt.window.set_titlebar(header);
  crypt.window.show_all();
  crypt.window.destroy.connect(()=>{
    crypt.m.quit();
    Gtk.main_quit();
    //indicator.visible = false;
  });

  Timeout.add (crypt.refreshRate * 1000, () => {

    walletTotalLabel.label = wallet.buildTotalText();

    return true;

  });

  crypt.spinner.active = true;
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

      if (currentPage != 0 && currentPage != (crypt.notebook.get_n_pages() - 1)){

        crypt.notebook.remove_page(currentPage);

      }

      ctrBool = false;
      wBool = false;

    }

    return false;

  });

  crypt.loadMainPage();

  Gtk.main();
  return 0;

}
