//
//  DJMWeatherTableViewController.swift
//  Meteo
//
//  Created by djabir sadaoui on 21/11/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

import Foundation
import UIKit
class DJMWeatherTableViewController: UITableViewController {
    let APIKEY:String = "&appid=2de143494c0b295cca9337e1e96b00e0"
    let URLBASE:String = "/data/2.5/forecast?id="
    let CITYID:String = "2968815"
    var WEATHER:DJMGlobalWeather?
    var dataWeather:NSArray?
    var fileManager:DJMFileManager?
    var isConnection:Bool = true
    @IBOutlet weak var headView:DJMHeadView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    override func viewDidLoad() {
        fileManager = DJMFileManager.sharedFileManager()
        getWeatherForCity(CITYID)
       
        super.viewDidLoad()
    }
    
    
    
    /**************** build cellule of table view **********************/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CelluleId = "Cellule"
        let Cellule = tableView.dequeueReusableCellWithIdentifier(CelluleId) as! DJMWeatherCellule
        
        let weather = dataWeather![indexPath.row*8] as! DJMWeatherWithDate
        let detail = weather.weathers?.allObjects[0] as! DJMWeather
        
        Cellule.dayLabel.text = getDayOfWeek(weather.dt_txt!)
        Cellule.minMaxLabel.text = getTemperature((weather.main?.temp_max)!)+"°  "+getTemperature((weather.main?.temp_min)!)+"°"
        Cellule.weatherLabel.text = detail.wDescription
        if (isConnection){
            let url = NSURL(string:"http://openweathermap.org/img/w/\(detail.icon!).png")
            let data =  NSData(contentsOfURL:url!)
            Cellule.iconImageView.image = UIImage(data: data!)
            let pathFile = fileManager!.fileInDocumentsDirectory(detail.icon!)
            fileManager!.saveImage(UIImage(data: data!)!, path: pathFile)
        }else{
            Cellule.iconImageView.image = fileManager!.loadImageFromPath(detail.icon!)
        }
       
        return Cellule
        
        
    }
    
  
   
   /************** when will show detail view ******************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetailWeather"){
            let controller = segue.destinationViewController as! DJMDetailWeatherController
            controller.WEATHER = WEATHER
            controller.celluleSelected = (self.tableView.indexPathForSelectedRow?.row)!
            let cellule = self.tableView.cellForRowAtIndexPath((self.tableView.indexPathForSelectedRow)!) as! DJMWeatherCellule
            controller.day = cellule.dayLabel.text!
            controller.isConnection = self.isConnection
            
        }
    }
    
    /**************** reurn number of row in section **********************/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dataWeather != nil){
            return 5
        }else{
            return 0
        }
    }
    
    /**************** return number of section in table view **********************/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /*************** return day for date in calendar ********************/
    func getDayOfWeek(today:String)->String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        switch (weekDay){
            case 1: return "Sunday"
            case 2: return "Monday"
            case 3: return "Tuesday"
            case 4: return "Wednesday"
            case 5: return "Thursday"
            case 6: return "Friday"
            case 7: return "Saturday"
        default: return "error"
        }
    }
    
    
    /**************** show header view in the home view **********************/
    func updateHeadView(){
        let firstWeather = dataWeather![0] as! DJMWeatherWithDate
        let detail = firstWeather.weathers!.allObjects[0] as! DJMWeather
        headView.tempsLabel.text = getTemperature((firstWeather.main?.temp)!)+"°"
        headView.cityLabel.text = WEATHER?.city?.name
        headView.descriptionLabel.text = detail.wDescription
        if(isConnection){
            let url = NSURL(string:"http://openweathermap.org/img/w/\(detail.icon!).png")
            let data =  NSData(contentsOfURL:url!)
            headView.img.image = UIImage(data: data!)
        }else{
             headView.img.image = fileManager!.loadImageFromPath(detail.icon!)
        }
        
    }
    
    /********* convert temprerature to C° ***********************/
    func getTemperature(temp:NSNumber)->(String){
       return NSString(format: "%.f", (Float(temp)-273.15)) as String
    }
    
    
    /**************** send request to the remote api weather **********************/
    @IBAction func refreshData(sender: AnyObject) {
       self.getWeatherForCity(CITYID)
    }
    
    func getWeatherForCity(cityID:String){
        let requestPath:String = URLBASE+cityID+APIKEY
        RKObjectManager.sharedManager().getObjectsAtPath(requestPath, parameters: nil, success: { (operation:RKObjectRequestOperation!, mappingResult:RKMappingResult!) -> Void in
             self.fetchWeatherFromContext()
            }) { (operation:RKObjectRequestOperation!, error:NSError!) -> Void in
             self.isConnection = false
             self.fetchWeatherFromContext()
            
        }
    }
    
    
    
    
     /**** retrieve data from data base ******/
   func fetchWeatherFromContext() {
    // retrieve context objects persistants -> NSManagedObjectContext(singleton)
    let context = RKManagedObjectStore.defaultStore().mainQueueManagedObjectContext
    // define extract request
    let fetchRequest = NSFetchRequest(entityName: "DJMGlobalWeather")
    var data = NSArray()
    do{
        // send request to data base
        data = try context.executeFetchRequest(fetchRequest)
    }
    catch let error as NSError {
        error.description
        
    }
    if(data.count != 0){
    WEATHER = data.firstObject as? DJMGlobalWeather
    
    let table:NSArray = (self.WEATHER!.list?.allObjects)!
    let descriptor = NSSortDescriptor(key: "dt", ascending: true)
    self.dataWeather = table.sortedArrayUsingDescriptors([descriptor])
    print(dataWeather?.count)
    self.updateHeadView()
    self.tableView.reloadData()
    }else{
        print("have not data local")
    }
    
    }
   
    
    /**************** when will need the memory **********************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
