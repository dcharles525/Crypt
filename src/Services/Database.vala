/*Special thanks to davidmhewitt and his app clipped for this code! (https://github.com/davidmhewitt/clipped/)*/
public class Database: GLib.Object {

  private Sqlite.Database database;
  private string dbLocation;

  public void createCheckDirectory(){

    var config_dir_path = Path.build_path (Path.DIR_SEPARATOR_S, Environment.get_user_config_dir(), "crypt");
    var config_dir = File.new_for_path (config_dir_path);

    if (!config_dir.query_exists ()) {

      try {

        config_dir.make_directory_with_parents ();

      } catch (Error e) {

        stderr.printf("Something went wrong making the storage directory");

      }

    }

    this.dbLocation = Path.build_path (Path.DIR_SEPARATOR_S, config_dir_path, "CryptStore.sqlite");

    if (File.new_for_path (this.dbLocation).query_exists ()) {

      openDatabase();
      prepareCoinListDatabase();
      prepareCoinLimitDatabase();
      prepareWalletDatabase();

    } else {

      openDatabase();
      prepareCoinListDatabase();
      prepareCoinLimitDatabase();
      prepareWalletDatabase();
      insertCoin("Bitcoin","BTC");

    }

  }

  private bool openDatabase() {

    int ec = Sqlite.Database.open(this.dbLocation, out this.database);

    if(ec != Sqlite.OK) {

      stderr.printf("Can't create database");
      return false;

    } else {

      return true;

    }

  }

  private void prepareCoinListDatabase() {

    string query = """
      CREATE TABLE coinlist (
        id          INTEGER PRIMARY KEY,
        coin_title  TEXT,
        coin_abbrv  TEXT
      );
    """;

    string error;
    int ec = this.database.exec (query, null, out error);

    if(ec != Sqlite.OK) {

      //stderr.printf("Can't use CREATE, Error: %s", error);

    }else{

      stderr.printf("Can't use CREATE, Error: %d", ec);

    }

  }

  private void prepareCoinLimitDatabase(){

    string query = """
      CREATE TABLE coinlimit (
        id          INTEGER PRIMARY KEY,
        coin_abbrv  TEXT,
        coin_high   TEXT,
        coin_low    TEXT,
        enabled     INTEGER
      );
    """;

    string error;
    int ec = this.database.exec (query, null, out error);

    if(ec != Sqlite.OK) {

      //stderr.printf("Can't use CREATE, Error: %s", error);

    }else{

      stderr.printf("Can't use CREATE, Error: %d", ec);

    }

  }

  private void prepareWalletDatabase(){

    string query = """
      CREATE TABLE wallet (
        id                 INTEGER PRIMARY KEY,
        coin_date          TEXT,
        coin_type          TEXT,
        coin_abbrv         TEXT,
        coin_amount        TEXT,
        coin_buy_price     TEXT,
        coin_current_price TEXT
      );
    """;

    string error;
    int ec = this.database.exec (query, null, out error);

    if(ec != Sqlite.OK) {

      //stderr.printf("Can't use CREATE, Error: %s", error);

    }else{

      stderr.printf("Can't use CREATE, Error: %d", ec);

    }

  }

  //For coin list
  public void insertCoin (string coinTitle, string coinAbbrv) {

    Sqlite.Statement stmt;

    string query = "INSERT INTO coinlist (coin_title, coin_abbrv) VALUES
    ($COINTITLE, $COINABBRV);";
    int ec = this.database.prepare_v2 (query, query.length, out stmt);

    if (ec != Sqlite.OK) {

	    stderr.printf("Error inserting clipboard entry: %s\n", this.database.errmsg());
	    return;

    }

    int param_position = stmt.bind_parameter_index ("$COINTITLE");
    assert (param_position > 0);
    stmt.bind_text (param_position, coinTitle);

    param_position = stmt.bind_parameter_index ("$COINABBRV");
    assert (param_position > 0);
    stmt.bind_text (param_position, coinAbbrv);

    ec = stmt.step();

		if (ec != Sqlite.DONE) {

			stderr.printf("Error inserting clipboard entry: %s\n", this.database.errmsg());

    }

  }

  public void deleteCoin(string coinAbbrv) {

    Sqlite.Statement stmt;

    string query = "DELETE FROM `coinlist` WHERE coin_abbrv = $COINABBRV;";
    int ec = this.database.prepare_v2 (query, query.length, out stmt);

    if (ec != Sqlite.OK) {

	    stderr.printf("Error deleting: %s\n", this.database.errmsg());
	    return;

    }

    int param_position = stmt.bind_parameter_index ("$COINABBRV");
    assert (param_position > 0);
    stmt.bind_text (param_position, coinAbbrv);

    ec = stmt.step();

		if (ec != Sqlite.DONE) {

			stderr.printf("Error deleting clipboard entry: %s\n", this.database.errmsg());

    }

  }

  public CoinList getCoins() {

    Sqlite.Statement stmt;
    CoinList coinList = new CoinList();

    const string query = "SELECT * FROM coinlist ORDER BY id ASC";
	  int ec = this.database.prepare_v2 (query, query.length, out stmt);

	  if (ec != Sqlite.OK) {

	    stderr.printf("Error fetching clipboard entries: %s\n", this.database.errmsg ());
	    return coinList;

    }

    while ((ec = stmt.step ()) == Sqlite.ROW) {

      coinList.coinIds.add(stmt.column_text(0));
      coinList.coinNames.add(stmt.column_text(1));
      coinList.coinAbbrvs.add(stmt.column_text(2));

		}

		return coinList;

  }

  //For limit list
  public void insertLimit (string coinAbbrv, string high, string low, bool enabled) {

    CoinLimit coinLimit = getLimit(coinAbbrv);

    if (coinLimit.coinIds.size > 0){

      Sqlite.Statement stmt;

      string query = "UPDATE coinlimit SET coin_high = $COINHIGH, coin_low = $COINLOW
      , enabled = $COINENABLED WHERE id = $COINID;";
      int ec = this.database.prepare_v2 (query, query.length, out stmt);

      if (ec != Sqlite.OK) {

  	    stderr.printf("Error inserting clipboard entry: %s\n", this.database.errmsg());
  	    return;

      }

      int param_position = stmt.bind_parameter_index ("$COINHIGH");
      assert (param_position > 0);
      stmt.bind_text (param_position, high.to_string());

      param_position = stmt.bind_parameter_index ("$COINLOW");
      assert (param_position > 0);
      stmt.bind_text (param_position, low.to_string());

      param_position = stmt.bind_parameter_index ("$COINENABLED");
      assert (param_position > 0);
      stmt.bind_int (param_position, (int)enabled);

      param_position = stmt.bind_parameter_index ("$COINID");
      assert (param_position > 0);
      stmt.bind_text (param_position, coinLimit.coinIds.get(0));

      ec = stmt.step();

  		if (ec != Sqlite.DONE) {

  			stderr.printf("Error inserting clipboard entry: %s\n", this.database.errmsg());

      }

    }else{

      Sqlite.Statement stmt;

      string query = "INSERT INTO coinlimit (coin_abbrv, coin_high, coin_low, enabled) VALUES
      ($COINABBRV, $COINHIGH, $COINLOW, $COINENABLED);";
      int ec = this.database.prepare_v2 (query, query.length, out stmt);

      if (ec != Sqlite.OK) {

  	    stderr.printf("Error inserting clipboard entry HERE: %s\n", this.database.errmsg());
  	    return;

      }

      int param_position = stmt.bind_parameter_index ("$COINABBRV");
      assert (param_position > 0);
      stmt.bind_text (param_position, coinAbbrv);

      param_position = stmt.bind_parameter_index ("$COINHIGH");
      assert (param_position > 0);
      stmt.bind_text (param_position, high);

      param_position = stmt.bind_parameter_index ("$COINLOW");
      assert (param_position > 0);
      stmt.bind_text (param_position, low);

      param_position = stmt.bind_parameter_index ("$COINENABLED");
      assert (param_position > 0);
      stmt.bind_int (param_position, (int)enabled);

      ec = stmt.step();

  		if (ec != Sqlite.DONE) {

  			stderr.printf("Error inserting clipboard entry: %s\n", this.database.errmsg());

      }

    }

  }

  public CoinLimit getLimits(){

    Sqlite.Statement stmt;
    CoinLimit coinLimit = new CoinLimit();

    const string query = "SELECT * FROM coinlimit ORDER BY id ASC";
	  int ec = this.database.prepare_v2 (query, query.length, out stmt);

	  if (ec != Sqlite.OK) {

	    stderr.printf("Error fetching clipboard entries: %s\n", this.database.errmsg ());
      return coinLimit;

    }

    while ((ec = stmt.step ()) == Sqlite.ROW) {

      coinLimit.coinIds.add(stmt.column_text(0));
      coinLimit.coinAbbrvs.add(stmt.column_text(1));
      coinLimit.coinHigh.add(stmt.column_text(2));
      coinLimit.coinLow.add(stmt.column_text(3));
      coinLimit.coinLow.add(stmt.column_text(4));

		}

    return coinLimit;

  }

  public CoinLimit getLimit(string coinAbbrv){

    Sqlite.Statement stmt;
    CoinLimit coinLimit = new CoinLimit();

    const string query = "SELECT * FROM coinlimit WHERE coin_abbrv = $COINABBRV;";
	  int ec = this.database.prepare_v2 (query, query.length, out stmt);

    int param_position = stmt.bind_parameter_index ("$COINABBRV");
    assert (param_position > 0);
    stmt.bind_text (param_position, coinAbbrv);

	  if (ec != Sqlite.OK) {

	    stderr.printf("Error fetching clipboard entries: %s\n", this.database.errmsg ());
      return coinLimit;

    }

    while ((ec = stmt.step ()) == Sqlite.ROW) {

      coinLimit.coinIds.add(stmt.column_text(0));
      coinLimit.coinAbbrvs.add(stmt.column_text(1));
      coinLimit.coinHigh.add(stmt.column_text(2));
      coinLimit.coinLow.add(stmt.column_text(3));
      coinLimit.coinEnabled.add(stmt.column_int(4));

		}

    stmt.reset();
    return coinLimit;

  }

  //For wallet
  public void insertWallet(string date, string type, string coinAbbrv, string amount,
  string priceAtPurchase, string currentPrice){

    Sqlite.Statement stmt;

    string query = "INSERT INTO wallet (coin_date, coin_type, coin_abbrv, coin_amount,
    coin_buy_price, coin_current_price) VALUES ($COINDATE, $COINTYPE, $COINABBRV,
    $COINAMOUNT, $COINBUYPRICE, $COINCURRENTPRICE);";
    int ec = this.database.prepare_v2 (query, query.length, out stmt);

    if (ec != Sqlite.OK) {

      stderr.printf("Error inserting clipboard entry HERE: %s\n", this.database.errmsg());
      return;

    }

    int param_position = stmt.bind_parameter_index ("$COINDATE");
    assert (param_position > 0);
    stmt.bind_text (param_position, date);

    param_position = stmt.bind_parameter_index ("$COINTYPE");
    assert (param_position > 0);
    stmt.bind_text (param_position, type);

    param_position = stmt.bind_parameter_index ("$COINABBRV");
    assert (param_position > 0);
    stmt.bind_text (param_position, coinAbbrv);

    param_position = stmt.bind_parameter_index ("$COINAMOUNT");
    assert (param_position > 0);
    stmt.bind_text (param_position, amount);

    param_position = stmt.bind_parameter_index ("$COINBUYPRICE");
    assert (param_position > 0);
    stmt.bind_text (param_position, priceAtPurchase);

    param_position = stmt.bind_parameter_index ("$COINCURRENTPRICE");
    assert (param_position > 0);
    stmt.bind_text (param_position, currentPrice);

    ec = stmt.step();

    if (ec != Sqlite.DONE) {

      stderr.printf("Error inserting clipboard entry: %s\n", this.database.errmsg());

    }

  }

  public WalletStorage getWallet(){

    Sqlite.Statement stmt;
    WalletStorage wallet = new WalletStorage();

    const string query = "SELECT * FROM wallet ORDER BY id DESC";
	  int ec = this.database.prepare_v2 (query, query.length, out stmt);

	  if (ec != Sqlite.OK) {

	    stderr.printf("Error fetching clipboard entries: %s\n", this.database.errmsg ());
      return wallet;

    }

    while ((ec = stmt.step ()) == Sqlite.ROW) {

      wallet.coinIds.add(stmt.column_int(0));
      wallet.coinDates.add(stmt.column_text(1));
      wallet.coinTypes.add(stmt.column_text(2));
      wallet.coinAbbrvs.add(stmt.column_text(3));
      wallet.coinAmounts.add(stmt.column_double(4));
      wallet.coinPurchasePrices.add(stmt.column_double(5));
      wallet.coinPrices.add(stmt.column_double(6));

		}

    return wallet;

  }

  public void deleteWalletCoin(int coinId){

    Sqlite.Statement stmt;

    string query = "DELETE FROM `wallet` WHERE id = $COINID;";
    int ec = this.database.prepare_v2 (query, query.length, out stmt);

    if (ec != Sqlite.OK) {

	    stderr.printf("Error deleting: %s\n", this.database.errmsg());
	    return;

    }

    int param_position = stmt.bind_parameter_index ("$COINID");
    assert (param_position > 0);
    stmt.bind_int (param_position, coinId);

    ec = stmt.step();

		if (ec != Sqlite.DONE) {

			stderr.printf("Error deleting clipboard entry: %s\n", this.database.errmsg());

    }

  }

}
