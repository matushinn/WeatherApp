//
//  TableViewController.swift
//  WeatherApp
//
//  Created by 大江祥太郎 on 2018/11/04.
//  Copyright © 2018年 shotaro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class TableViewController: UITableViewController {

    var prefectures: [Pref] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Alamofireを利用して通信を行います。
        Alamofire.request("https://query.yahooapis.com/v1/public/yql?q=select*%20from%20xml%20where%20url%20%3D%20%27http%3A%2F%2Fweather.livedoor.com%2Fforecast%2Frss%2Fprimary_area.xml%27&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys").responseJSON { (response: DataResponse<Any>) in
            
            if response.result.isFailure == true {
               self.simpleAlert(title: "通信エラー", message: "通信に失敗しました")
                return
            }
            // "guard let 変数 〜 else" で変数の中身がnilの場合のみの処理が書けます。
            // ただし最後に必ずreturnで関数を終了させなければいけません。
            // 変数は以後の関数内でも利用できます。
            guard let val = response.result.value as? [String:Any] else {
                self.simpleAlert(title: "通信エラー", message: "通信エラーはJSONではありませんでした。")
                return
            }
            // responseJSONを使うと辞書形式でも扱えますが、今回はより簡単に扱うためにSwiftyJSONを利用します。
            let json = JSON(val)
            // 取得データを扱いやすいデータに変更
            let prefJSON = json["query"]["results"]["rss"]["channel"]["source"]["pref"].arrayValue
            
            self.prefectures = prefJSON.map {item in
                return Pref(pref: item)
            }
            //テーブルにデータを反映
            self.tableView.reloadData()

        }
            

    }
    func simpleAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        present(alert,animated: true,completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return prefectures.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let cities = prefectures[section].cities
        return cities.count
    }
    //セクションのタイトルを返す
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return prefectures[section].title
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefCell", for: indexPath) as! TableViewCell

        // Configure the cell...
        cell.titleLabel.text = prefectures[indexPath.section].cities[indexPath.row].title
        cell.idLabel.text = prefectures[indexPath.section].cities[indexPath.row].id
        

        return cell
    }
    // MARK: - Navigation
    
    // 画面遷移時に地域IDを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先がDetailViewControllerであること
        if let detailVC = segue.destination as? DetailViewController {
            // 選択したセルが持つIDを取得し、遷移先に渡す
            if let cell = sender as? TableViewCell, let indexPath = tableView.indexPath(for: cell) {
                detailVC.cityID = prefectures[indexPath.section].cities[indexPath.row].id
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
