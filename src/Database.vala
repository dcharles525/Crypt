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
      
    } else {
      
      openDatabase();
      prepareDatabase();
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
  
  private void prepareDatabase() {
  
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
    
      stderr.printf("Can't use CREATE, Error: %s", error);
      
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
  
}
