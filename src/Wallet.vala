using Soup;
using Gtk;
using Json;
using WebKit;
using Gee;
using Cairo;

public class Wallet{

  public double total = 0;
  public double gainLoss = 0;
  public Gtk.TreeView walletTreeView = new Gtk.TreeView();
  public Gtk.ListStore listModel = new Gtk.ListStore(6, typeof (string), typeof (string),
  typeof (string), typeof (string), typeof (string), typeof (string));
  private int firstRun = 0;
  private int refreshRate = 30;

  public Wallet(){

    GLib.Settings settings = new GLib.Settings ("com.github.dcharles525.crypt");

    if (settings != null){

      settings.get ("refresh-rate", "i", out this.refreshRate);

    }else{

      this.refreshRate = 30;

    }

  }

  public Gtk.Box buildTable(){

    Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

    this.walletTreeView.button_press_event.connect ((event) => {

      if (event.type == Gdk.EventType.BUTTON_PRESS && event.button == 3) {

        TreePath path; TreeViewColumn column; int cell_x; int cell_y;
				this.walletTreeView.get_path_at_pos ((int)event.x, (int)event.y, out path, out column, out cell_x, out cell_y);
				this.walletTreeView.grab_focus();
     		this.walletTreeView.set_cursor(path,column,false);

				TreeSelection aTreeSelection = this.walletTreeView.get_selection ();

        if(aTreeSelection.count_selected_rows() == 1){

          Gtk.Menu menu = new Gtk.Menu ();

          Gtk.MenuItem menuItem = new Gtk.MenuItem.with_label (_("Delete"));
          menu.attach_to_widget (this.walletTreeView, null);
          menu.add (menuItem);
          menuItem.activate.connect((e) => {

            var selection = this.walletTreeView.get_selection();
            selection.set_mode(SelectionMode.SINGLE);

            TreeModel model;
            TreeIter iter;

            if (selection.get_selected(out model, out iter)) {

              path = model.get_path(iter);
              int index = int.parse(path.to_string());

              Database dbObject = new Database();
              dbObject.createCheckDirectory();
              WalletStorage walletList = dbObject.getWallet();

              int coinId = walletList.coinIds.get(index);

              dbObject.createCheckDirectory();
              dbObject.deleteWalletCoin(coinId);
              this.insertRows();

            }
          });

          menu.show_all ();
          menu.popup (null, null, null, event.button, event.time);

        }

        return true;

      }

      return false;

    });

    this.walletTreeView.activate_on_single_click = true;
    this.walletTreeView.get_style_context().add_class("table");

    this.listModel = new Gtk.ListStore (7, typeof (string), typeof (string),
    typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
    this.walletTreeView.set_model (listModel);

    var dateText = new CellRendererText ();

    var dateColumn = new Gtk.TreeViewColumn ();
    dateColumn.set_title (_("Date"));
    dateColumn.max_width = -1;
    dateColumn.min_width = 100;
    dateColumn.pack_start (dateText, false);
    dateColumn.resizable = true;
    dateColumn.reorderable = true;
    dateColumn.sort_column_id = 0;
    dateColumn.set_attributes (dateText, "text", 0);
    dateColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

    this.walletTreeView.append_column(dateColumn);

    var typeText = new CellRendererText ();

    var typeColumn = new Gtk.TreeViewColumn ();
    typeColumn.set_title (_("Buy/Sell"));
    typeColumn.max_width = -1;
    typeColumn.min_width = 100;
    typeColumn.pack_start (typeText, false);
    typeColumn.resizable = true;
    typeColumn.reorderable = true;
    typeColumn.sort_column_id = 0;
    typeColumn.set_attributes (typeText, "text", 1);
    typeColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

    this.walletTreeView.append_column(typeColumn);

    var labelText = new CellRendererText ();

    var coinColumn = new Gtk.TreeViewColumn ();
    coinColumn.set_title (_("Coin"));
    coinColumn.max_width = -1;
    coinColumn.min_width = 100;
    coinColumn.pack_start (labelText, false);
    coinColumn.resizable = true;
    coinColumn.reorderable = true;
    coinColumn.sort_column_id = 0;
    coinColumn.set_attributes (labelText, "text", 2);
    coinColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

    this.walletTreeView.append_column(coinColumn);

    var gainLossText = new CellRendererText ();

    var gainLossColumn = new Gtk.TreeViewColumn ();
    gainLossColumn.set_title (_("Gain/Loss"));
    gainLossColumn.max_width = -1;
    gainLossColumn.min_width = 100;
    gainLossColumn.pack_start (gainLossText, false);
    gainLossColumn.resizable = true;
    gainLossColumn.reorderable = true;
    gainLossColumn.sort_column_id = 0;
    gainLossColumn.set_attributes (gainLossText, "text", 3);
    gainLossColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

    this.walletTreeView.append_column(gainLossColumn);

    var quantityText = new CellRendererText ();

    var quantityColumn = new Gtk.TreeViewColumn ();
    quantityColumn.set_title (_("Quantity"));
    quantityColumn.max_width = -1;
    quantityColumn.min_width = 100;
    quantityColumn.pack_start (quantityText, false);
    quantityColumn.resizable = true;
    quantityColumn.reorderable = true;
    quantityColumn.sort_column_id = 0;
    quantityColumn.set_attributes (quantityText, "text", 4);
    quantityColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

    this.walletTreeView.append_column(quantityColumn);

    var enterPriceText = new CellRendererText ();

    var enterPriceColumn = new Gtk.TreeViewColumn ();
    enterPriceColumn.set_title (_("Price Entered"));
    enterPriceColumn.max_width = -1;
    enterPriceColumn.min_width = 100;
    enterPriceColumn.pack_start (enterPriceText, false);
    enterPriceColumn.resizable = true;
    enterPriceColumn.reorderable = true;
    enterPriceColumn.sort_column_id = 0;
    enterPriceColumn.set_attributes (enterPriceText, "text", 5);
    enterPriceColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

    this.walletTreeView.append_column(enterPriceColumn);

    var coinPriceText = new CellRendererText ();

    var coinPriceColumn = new Gtk.TreeViewColumn ();
    coinPriceColumn.set_title (_("Coin Price"));
    coinPriceColumn.max_width = -1;
    coinPriceColumn.min_width = 100;
    coinPriceColumn.pack_start (coinPriceText, false);
    coinPriceColumn.resizable = true;
    coinPriceColumn.reorderable = true;
    coinPriceColumn.sort_column_id = 0;
    coinPriceColumn.set_attributes (coinPriceText, "text", 6);
    coinPriceColumn.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

    this.walletTreeView.append_column(coinPriceColumn);

    Gtk.Button addWalletButton = new Gtk.Button.with_label(_("Add To Wallet"));
    addWalletButton.get_style_context().add_class("button-color");

    addWalletButton.clicked.connect (() => {

      this.openWalletDialog();

    });

    Gtk.Button sellWalletButton = new Gtk.Button.with_label(_("Sell Coin"));
    sellWalletButton.get_style_context().add_class("button-color-sell");

    sellWalletButton.clicked.connect (() => {

      this.openSellDialog();

    });

    box.pack_start(this.walletTreeView);
    box.pack_start(addWalletButton,false,false);
    box.pack_start(sellWalletButton,false,false);

    Timeout.add (this.refreshRate * 1000, () => {

      this.insertRows();

      return true;

    });

    return box;

  }

  public void insertRows(){

    this.listModel.clear();
    Database dbObject = new Database();
    dbObject.createCheckDirectory();
    WalletStorage walletList = dbObject.getWallet();
    double tempTotal = 0;
    double tempGainLoss = 0;
    double coinQuantity = 0;
    double diff = 0;
    TreeIter iter;
    Coin coin = new Coin();

    for (int i = 0; i < walletList.coinIds.size; i++){

      if (walletList.coinTypes.get(i) == "buy"){

        coin.getCurrentPrice(walletList.coinAbbrvs.get(i));
        coinQuantity = walletList.coinAmounts.get(i);

        diff = coinQuantity*((double)coin.rawPrice) - coinQuantity*(walletList.coinPurchasePrices.get(i));

        tempGainLoss = tempGainLoss + diff;

        tempTotal = tempTotal + coinQuantity*((double)coin.rawPrice);

      }else{

        coinQuantity = walletList.coinAmounts.get(i);
        double coinPrice = walletList.coinPrices.get(i);

        tempTotal = tempTotal - (coinQuantity*coinPrice);

      }

      this.listModel.append (out iter);
      this.listModel.set(iter, 0, walletList.coinDates.get(i), 1, walletList.coinTypes.get(i), 2,walletList.coinAbbrvs.get(i), 3, "$".concat(diff.to_string()),
      4, coinQuantity.to_string(), 5, walletList.coinPurchasePrices.get(i).to_string(), 6, coin.rawPrice.to_string());

    }

    this.total = tempTotal;

    this.listModel.append (out iter);
    this.listModel.set(iter, 0, "", 1, "", 2, _("Total Wallet Value: "), 3, this.buildTotalText(),
    4, "---", 5, "---", 6, "---");

    this.listModel.append (out iter);
    this.listModel.set(iter, 0, "", 1, "", 2, _("Total Gain/Losss Value: "), 3, "$".concat(tempGainLoss.to_string()),
    4, "---", 5, "---", 6, "---");

  }

  public void openWalletDialog(){

    Gtk.Label mainLabel = new Gtk.Label(_("Add to Wallet"));
    mainLabel.get_style_context().add_class("large-text");

    Gtk.Label coinLabel = new Gtk.Label(_("Coin Abbreviation"));
    coinLabel.xalign = 0;
    Entry coinAbbrevEntry = new Entry();

    Gtk.Label dateLabel = new Gtk.Label(_("Date Bought"));
    dateLabel.xalign = 0;
    Granite.Widgets.DatePicker datePicker = new Granite.Widgets.DatePicker();

    Gtk.Label coinAmountLabel = new Gtk.Label(_("Coin Amount"));
    coinAmountLabel.xalign = 0;
    Entry coinAmountEntry = new Entry();

    Gtk.Label coinPricePurchaseLabel = new Gtk.Label(_("Coin Price at Purchase"));
    coinPricePurchaseLabel.xalign = 0;
    Entry coinPricePurchase = new Entry();

    Gtk.Button addWalletButton = new Gtk.Button.with_label(_("Add To Wallet"));
    addWalletButton.get_style_context().add_class("button-color");

    Gtk.Dialog dialog = new Gtk.Dialog ();
    dialog.width_request = 500;
    dialog.get_content_area().spacing = 7;
    dialog.get_content_area().border_width = 10;
    dialog.get_content_area().pack_start(mainLabel,false,false);
    dialog.get_content_area().pack_start(dateLabel,false,false);
    dialog.get_content_area().pack_start(datePicker,false,false);
    dialog.get_content_area().pack_start(coinLabel,false,false);
    dialog.get_content_area().pack_start(coinAbbrevEntry,false,false);
    dialog.get_content_area().pack_start(coinAmountLabel,false,false);
    dialog.get_content_area().pack_start(coinAmountEntry,false,false);
    dialog.get_content_area().pack_start(coinPricePurchaseLabel,false,false);
    dialog.get_content_area().pack_start(coinPricePurchase,false,false);
    dialog.get_content_area().pack_start(addWalletButton,false,false);
    dialog.get_widget_for_response(Gtk.ResponseType.OK).can_default = true;
    dialog.set_default_response(Gtk.ResponseType.OK);
    dialog.show_all();

    addWalletButton.clicked.connect (() => {

      int year, month, day;
      datePicker.date.get_ymd(out year, out month, out day);
      string date = month.to_string().concat("-",day.to_string(),"-",year.to_string());

      Database database = new Database();
      database.createCheckDirectory();
      Coin coin = new Coin();

      if (coin.checkCoin(coinAbbrevEntry.get_text()) == 1){

        coin.getCoinInfoFull(coinAbbrevEntry.get_text());
        database.insertWallet(date,"buy",coinAbbrevEntry.get_text(),coinAmountEntry.get_text(),
        coinPricePurchase.get_text(),(string)coin.price);

        dialog.close();
        this.insertRows();

      }

    });

  }

  public void openSellDialog(){

    Gtk.Label mainLabel = new Gtk.Label(_("Sell Coin"));
    mainLabel.get_style_context().add_class("large-text");

    Gtk.Label coinLabel = new Gtk.Label(_("Coin Abbreviation"));
    coinLabel.xalign = 0;
    Entry coinAbbrevEntry = new Entry();

    Gtk.Label dateLabel = new Gtk.Label(_("Date Bought"));
    Granite.Widgets.DatePicker datePicker = new Granite.Widgets.DatePicker();

    Gtk.Label coinAmountLabel = new Gtk.Label(_("Coin Amount"));
    coinAmountLabel.xalign = 0;
    Entry coinAmountEntry = new Entry();

    Gtk.Label coinSellLabel = new Gtk.Label(_("Coin Selling Price"));
    coinLabel.xalign = 0;
    Entry coinSellEntry = new Entry();

    Gtk.Button sellWalletButton = new Gtk.Button.with_label(_("Sell"));
    sellWalletButton.get_style_context().add_class("button-color");

    Gtk.Dialog dialog = new Gtk.Dialog ();
    dialog.width_request = 500;
    dialog.get_content_area().spacing = 7;
    dialog.get_content_area().border_width = 10;
    dialog.get_content_area().pack_start(mainLabel,false,false);
    dialog.get_content_area().pack_start(dateLabel,false,false);
    dialog.get_content_area().pack_start(datePicker,false,false);
    dialog.get_content_area().pack_start(coinLabel,false,false);
    dialog.get_content_area().pack_start(coinAbbrevEntry,false,false);
    dialog.get_content_area().pack_start(coinAmountLabel,false,false);
    dialog.get_content_area().pack_start(coinAmountEntry,false,false);
    dialog.get_content_area().pack_start(coinSellLabel,false,false);
    dialog.get_content_area().pack_start(coinSellEntry,false,false);
    dialog.get_content_area().pack_start(sellWalletButton,false,false);
    dialog.get_widget_for_response(Gtk.ResponseType.OK).can_default = true;
    dialog.set_default_response(Gtk.ResponseType.OK);
    dialog.show_all();

    sellWalletButton.clicked.connect (() => {

      int year, month, day;
      datePicker.date.get_ymd(out year, out month, out day);
      string date = month.to_string().concat("-",day.to_string(),"-",year.to_string());

      Database database = new Database();
      database.createCheckDirectory();
      Coin coin = new Coin();

      if (coin.checkCoin(coinAbbrevEntry.get_text()) == 1){

        database.insertWallet(date,"sell",coinAbbrevEntry.get_text(),coinAmountEntry.get_text(),
        "",coinSellEntry.get_text());

        dialog.close();
        this.insertRows();

      }

    });

  }

  public string buildTotalText(){

    string tempWalletTotal = this.total.to_string();
    string[] priceSplit = tempWalletTotal.split (".");

    if (priceSplit[1] != null){

      tempWalletTotal = "$".concat(priceSplit[0],".",priceSplit[1].substring(0, 2));

    }else{

      tempWalletTotal = "$0";

    }

    return tempWalletTotal;

  }

}
