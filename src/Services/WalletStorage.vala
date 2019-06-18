using Gee;

public class WalletStorage{

  public double totalValue {get; set;}
  public ArrayList<string> coinDates = new ArrayList<string>();
  public ArrayList<string> coinTypes = new ArrayList<string>();
  public ArrayList<int> coinIds = new ArrayList<int>();
  public ArrayList<string> coinAbbrvs = new ArrayList<string>();
  public ArrayList<double?> coinAmounts = new ArrayList<double?>();
  public ArrayList<double?> coinPurchasePrices = new ArrayList<double?>();
  public ArrayList<double?> coinPrices = new ArrayList<double?>();

}
