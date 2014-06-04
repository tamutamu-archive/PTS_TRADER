import util.http._

object Main {
  def main(args: Array[String]): Unit = {
    
    val httpc1 = HttpScrayper("http://www.morningstar.co.jp/StockInfo/pts/ranking?kind=0&page=0");
    val httpc2 = HttpScrayper("http://www.morningstar.co.jp/StockInfo/pts/ranking?kind=0&page=1");
    
    val httpc = httpc1.scrape ++ httpc2.scrape
    
    println("")
    println("----------------------------------------------------------------------------------------")
    httpc.filter( st => st._3.diff("%").toFloat > 3.00 && st._5.replaceAll(",","").toLong > 500000 && st._6.replaceAll("[,|.]","").toLong <= 300 ).foreach(println(_))
    println("----------------------------------------------------------------------------------------")
    println("")
    
  }
}	