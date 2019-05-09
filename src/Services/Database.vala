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

    } else {

      openDatabase();
      prepareCoinListDatabase();
      prepareCoinLimitDatabase();
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

}
