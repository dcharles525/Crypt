public class MainPageCharts: Gtk.Window{

  public MainPageCharts(){

  }

  //public Gtk.Box getMainPageCharts(){

    /*this.coinNames.clear();
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

    this.mainAreaTreeView = new TreeView ();
    this.mainAreaTreeView.button_press_event.connect ((event) => {

      if (event.type == Gdk.EventType.BUTTON_PRESS && event.button == 3) {

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

      return false;

    });

    this.mainAreaTreeView.activate_on_single_click = false;
    this.mainAreaTreeView.get_style_context().add_class("table");

    this.listModel = new Gtk.ListStore (8, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
    this.mainAreaTreeView.set_model (listModel);

    var text = new CellRendererText ();

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

                    var notification = new GLib.Notification (("Limit Notification! ".concat(coinLimit.coinAbbrvs.get(g))));
                    notification.set_body ((coinLimit.coinAbbrvs.get(g).concat(" just hit ",coinLimit.coinHigh.get(g),"!!")));
                    this.send_notification ("com.github.dcharles525.crypt", notification);

                  }

                  if (rawPrice <= double.parse(coinLimit.coinLow.get(g))){

                    var notification = new GLib.Notification (("Limit Notification! ".concat(coinLimit.coinAbbrvs.get(g))));
                    notification.set_body ((coinLimit.coinAbbrvs.get(g).concat(" just dropped to ",coinLimit.coinLow.get(g),"!!")));
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
    scroll.add (this.mainAreaTreeView);
    scroll.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
    verticalGridBox.pack_start(scroll);

    return verticalGridBox;*/

  //}

}
