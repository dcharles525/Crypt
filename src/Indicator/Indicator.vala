public class Indicator : Wingpanel.Indicator {

  private Gtk.Label display_widget;
  private Gtk.Grid main_widget;

  public Indicator () {

    Object (
      code_name : "dcharles525-crypt",
      display_name : _("Price Indicator"),
      description: _("Shows prices of coins in the users list.")
    );

  }

  construct {

    this.visible = false;
    display_widget = new Gtk.Label (_("Loading"));

    var hide_button = new Gtk.ModelButton ();
    hide_button.text = _("Close");

    var compositing_switch = new Wingpanel.Widgets.Switch (_("Composited Icon"));

    main_widget = new Gtk.Grid ();
    main_widget.attach (hide_button, 0, 0);
    main_widget.attach (new Wingpanel.Widgets.Separator (), 0, 1);
    main_widget.attach (compositing_switch, 0, 2);

    hide_button.clicked.connect (() => {
        //this.visible = false;
    });

    keepUpdating(0);

  }

  public override Gtk.Widget get_display_widget () {

    return display_widget;

  }

  public override Gtk.Widget? get_widget () {

    return main_widget;

  }

  public override void opened () {

  }

  public override void closed () {

    this.visible = false;

  }

  public void keepUpdating(int coinOrder){

    Database dbObject = new Database();
    dbObject.createCheckDirectory();
    CoinList coinList = dbObject.getCoins();

    if (coinOrder == coinList.coinIds.size){

      coinOrder = 0;

    }

    Timeout.add (10000, () => {

      var currentCoin = new Coin();
      currentCoin.getCoinInfoFull(coinList.coinAbbrvs.get(coinOrder));

      display_widget.label = coinList.coinAbbrvs.get(coinOrder).concat(" ",currentCoin.price);
      keepUpdating(coinOrder+1);
      return false;

    });

  }

}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {

  if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {

    return null;

  }

  var indicator = new Indicator ();
  return indicator;
  
}
