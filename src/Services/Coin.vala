public class Coin{

  public string assumedAbbrv {get; set;}
  public string name {get; set; }
  public string abbrv {get; set;}
  public string price {get; set;}
  public string lastUpdate {get; set;}
  public string lastVolume {get; set;}
  public string lastVolumeTo {get; set;}
  public string lastTradeID {get; set;}
  public string volumeDay {get; set;}
  public string volumeDayTo {get; set;}
  public string volume24Hour {get; set;}
  public string volume24HourTo {get; set;}
  public string openDay {get; set;}
  public string highDay {get; set;}
  public string lowDay {get; set;}
  public string open24Hour {get; set;}
  public string high24Hour {get; set;}
  public string low24Hour {get; set;}
  public string lastMarket {get; set;}
  public string change24Hour {get; set;}
  public string changeP24Hour {get; set;}
  public string changeDay {get; set;}
  public string changePDay {get; set;}
  public string supply {get; set;}
  public string mCap {get; set;}
  public string totalVolume24Hour {get; set;}
  public string totalVolume24HTo {get; set;}
  public double rawPrice {get; set;}

  public double[] DATA { get; set; }
  public double[] HIGH { get; set; }
  public double[] LOW { get; set; }

  public Coin(){

  }

  public void getCoinInfoFull(string coinAbrv){

    MainLoop loop = new MainLoop ();
    var settings = new GLib.Settings ("com.github.dcharles525.crypt");
    string defaultCoin = "";

    if (settings != null){

      defaultCoin = settings.get_value("main-coin").get_string();

    }else{

      defaultCoin = "USD";

    }

    Soup.Session session = new Soup.Session();
	  Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=".concat(coinAbrv,"&tsyms=",defaultCoin));

    session.queue_message (message, (sess, message) => {

      if (message.status_code == 200) {

        try {

          var parser = new Json.Parser ();
          parser.load_from_data((string) message.response_body.flatten().data, -1);
          var root_object = parser.get_root ().get_object ();
          var data = root_object.get_object_member ("DISPLAY").get_object_member(coinAbrv).get_object_member(defaultCoin);

          this.assumedAbbrv = coinAbrv;
          this.abbrv = data.get_string_member("FROMSYMBOL");
          this.price = data.get_string_member("PRICE");
          this.lastUpdate = data.get_string_member("LASTUPDATE");
          this.lastVolume = data.get_string_member("LASTVOLUME");
          this.lastVolumeTo = data.get_string_member("LASTVOLUMETO");
          this.lastTradeID = data.get_string_member("LASTTRADEID");
          this.volumeDay = data.get_string_member("VOLUMEDAY");
          this.volumeDayTo = data.get_string_member("VOLUMEDAYTO");
          this.volume24Hour = data.get_string_member("VOLUME24HOUR");
          this.volume24HourTo = data.get_string_member("VOLUME24HOURTO");
          this.openDay = data.get_string_member("OPENDAY");
          this.highDay = data.get_string_member("HIGHDAY");
          this.lowDay = data.get_string_member("LOWDAY");
          this.open24Hour = data.get_string_member("OPEN24HOUR");
          this.high24Hour = data.get_string_member("HIGH24HOUR");
          this.low24Hour = data.get_string_member("LOW24HOUR");
          this.lastMarket = data.get_string_member("LASTMARKET");
          this.change24Hour = data.get_string_member("CHANGE24HOUR");
          this.changeP24Hour = data.get_string_member("CHANGEPCT24HOUR");
          this.changeDay = data.get_string_member("CHANGEDAY");
          this.changePDay = data.get_string_member("CHANGEPCTDAY");
          this.supply = data.get_string_member("SUPPLY");
          this.mCap = data.get_string_member("MKTCAP");
          this.totalVolume24Hour = data.get_string_member("TOTALVOLUME24H");
          this.totalVolume24HTo = data.get_string_member("TOTALVOLUME24HTO");

          loop.quit();

        }catch (Error e) {

          stderr.printf ("Something is wrong in getCurrentPrice");

        }

      }

    });

    loop.run();

  }

  public void getPriceDataHour(string coin){

    MainLoop loop = new MainLoop ();
    var settings = new GLib.Settings ("com.github.dcharles525.crypt");
    string defaultCoin = "";

    if (settings != null){

      defaultCoin = settings.get_value("main-coin").get_string();

    }else{

      defaultCoin = "USD";

    }

    Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/histominute?fsym=".concat(coin,"&tsym=",defaultCoin,"&limit=30"));

    session.queue_message (message, (sess, message) => {

      if (message.status_code == 200) {

        double[] DATA = {};
        double[] HIGH = {};
        double[] LOW = {};

		    try {

			    var parser = new Json.Parser ();
          parser.load_from_data((string) message.response_body.flatten().data, -1);
          var root_object = parser.get_root ().get_object ();
          var response = root_object.get_array_member ("Data");

          foreach (var data in response.get_elements()) {

            //int64 time = data.get_object().get_int_member("time");
            double price = data.get_object().get_double_member("close");
            double high = data.get_object().get_double_member("high");
            double low = data.get_object().get_double_member("low");

            DATA += price;
            HIGH += high;
            LOW += low;

          }

          this.DATA = DATA;
          this.HIGH = HIGH;
          this.LOW = LOW;

        }catch (Error e) {

          stderr.printf ("Something is wrong in getPriceData");

        }

      }

      loop.quit();

    });

    loop.run();

  }

  public void getPriceDataDay(string coin){

    MainLoop loop = new MainLoop ();
    var settings = new GLib.Settings ("com.github.dcharles525.crypt");
    string defaultCoin = "";

    if (settings != null){

      defaultCoin = settings.get_value("main-coin").get_string();

    }else{

      defaultCoin = "USD";

    }

    Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/histohour?fsym=".concat(coin,"&tsym=",defaultCoin,"&limit=24"));

    session.queue_message (message, (sess, message) => {

      if (message.status_code == 200) {

        double[] DATA = {};
        double[] HIGH = {};
        double[] LOW = {};

		    try {

			    var parser = new Json.Parser ();
          parser.load_from_data((string) message.response_body.flatten().data, -1);
          var root_object = parser.get_root ().get_object ();
          var response = root_object.get_array_member ("Data");

          foreach (var data in response.get_elements()) {

            //int64 time = data.get_object().get_int_member("time");
            double price = data.get_object().get_double_member("close");
            double high = data.get_object().get_double_member("high");
            double low = data.get_object().get_double_member("low");

            DATA += price;
            HIGH += high;
            LOW += low;

          }

          this.DATA = DATA;
          this.HIGH = HIGH;
          this.LOW = LOW;

        }catch (Error e) {

          stderr.printf ("Something is wrong in getPriceData");

        }

        loop.quit();

      }

    });

    loop.run();

  }

  public void getPriceDataWeek(string coin){

    MainLoop loop = new MainLoop ();
    var settings = new GLib.Settings ("com.github.dcharles525.crypt");
    string defaultCoin = "";

    if (settings != null){

      defaultCoin = settings.get_value("main-coin").get_string();

    }else{

      defaultCoin = "USD";

    }

    Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/histoday?fsym=".concat(coin,"&tsym=",defaultCoin,"&limit=6"));

    session.queue_message (message, (sess, message) => {

      if (message.status_code == 200) {

        double[] DATA = {};
        double[] HIGH = {};
        double[] LOW = {};

		    try {

			    var parser = new Json.Parser ();
          parser.load_from_data((string) message.response_body.flatten().data, -1);
          var root_object = parser.get_root ().get_object ();
          var response = root_object.get_array_member ("Data");

          foreach (var data in response.get_elements()) {

            //int64 time = data.get_object().get_int_member("time");
            double price = data.get_object().get_double_member("close");
            double high = data.get_object().get_double_member("high");
            double low = data.get_object().get_double_member("low");

            DATA += price;
            HIGH += high;
            LOW += low;

          }

          this.DATA = DATA;
          this.HIGH = HIGH;
          this.LOW = LOW;

        }catch (Error e) {

          stderr.printf ("Something is wrong in getPriceData");

        }

        loop.quit();

      }

    });

    loop.run();

  }

  public void getCurrentPrice(string coin){

    var settings = new GLib.Settings ("com.github.dcharles525.crypt");
    string defaultCoin = "";
    double price = 0;

    if (settings != null){

      defaultCoin = settings.get_value("main-coin").get_string();

    }else{

      defaultCoin = "USD";

    }

    MainLoop loop = new MainLoop ();

    Soup.Session session = new Soup.Session();
    Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/pricemulti?fsyms=".concat(coin,"&tsyms=",defaultCoin));

    session.queue_message (message, (sess, message) => {

      if (message.status_code == 200) {

        try {

          var parser = new Json.Parser ();
          parser.load_from_data((string) message.response_body.flatten().data, -1);
          var root_object = parser.get_root ().get_object ();
          var data = root_object.get_object_member (coin);
          this.rawPrice = data.get_double_member("USD");

        }catch (Error e) {

          stderr.printf ("Something is wrong in coin");

        }

        loop.quit();

      }

    });

    loop.run();

  }

  public int checkCoin(string coinAbrv){

    MainLoop loop = new MainLoop ();
    var settings = new GLib.Settings ("com.github.dcharles525.crypt");
    string defaultCoin = "";

    if (settings != null){

      defaultCoin = settings.get_value("main-coin").get_string();

    }else{

      defaultCoin = "BTC";

    }

    int coinExists = 0;

    Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/histominute?fsym=".concat(coinAbrv,"&tsym=",defaultCoin,"&limit=1"));

    session.queue_message (message, (sess, message) => {

      if (message.status_code == 200) {

		    try {

          var parser = new Json.Parser ();
          parser.load_from_data((string) message.response_body.flatten().data, -1);
          var root_object = parser.get_root ().get_object ();
          var response = root_object.get_array_member ("Data");

          foreach (var data in response.get_elements()) {

            double price = data.get_object().get_double_member("close");

            if (price > 0){

              coinExists = 1;

            }else{

              coinExists = 0;

            }

          }

        }catch (Error e) {

          stderr.printf ("Something is wrong in validating coin");

        }

      }else{

        coinExists = 0;

      }

      loop.quit();

    });

    loop.run();
    return coinExists;

  }

}
