public class CoinListWidget : Gtk.Box {

  private Gtk.Label priceLabel;

  construct {

    var currentCoin = new Coin();
    priceLabel = new Gtk.Label (_("Loading"));
    pack_start (priceLabel);

    currentCoin.getCoinInfoFull("BTC");
    priceLabel.label = currentCoin.price;
    priceLabel.margin = 1;

  }

  public CoinListWidget () {

    orientation = Gtk.Orientation.HORIZONTAL;

  }

}
