package util.http
import scala.collection.JavaConversions._

import org.openqa.selenium.htmlunit.HtmlUnitDriver
import org.openqa.selenium.{ By, WebElement }

class HttpScrayper private(url:String) {

   //基本コンストラクタ
  private val driver: HtmlUnitDriver = new HtmlUnitDriver()
  //プロクシ設定
  //driver.setProxy("", 0);
  driver.get(url)

  //要素アクセス定数宣言
  private val CODE = 2
  private val NAME = 3
  private val CUR_PRICE = 6
  private val UP_LATE = 8
  private val VOL = 9
  private val BILL = 10

  /**
  * スクレイピング処理
  **/
  def scrape = {
    
    try{

    def ff(_tr:WebElement)(idx:Int) = _tr.findElement(By.xpath(s"td[${idx}]")).getText

    driver.findElementByXPath("//table[@class=\"sr-tbl\"]")
          .findElements(By.xpath("./tbody/tr"))
          .map( tr => {
          				
                        val ff2 = ff(tr)_
                        (ff2(CODE), ff2(NAME), ff2(UP_LATE), ff2(VOL), ff2(BILL), ff2(CUR_PRICE))
                      }
              )
    }
    finally{
    	driver.close()
    }
  }

}

object HttpScrayper {

  def apply(url:String) = new HttpScrayper(url)

}
