//
//  DJMDetailWeatherController.swift
//  Meteo
//
//  Created by djabir sadaoui on 22/11/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

import Foundation

class DJMDetailWeatherController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headView: DJMHeadDetailView!
    @IBOutlet weak var collectionWeatherView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    var celluleSelected:Int = 0
    var WEATHER:DJMGlobalWeather!
    var day:String = ""
    var dataWeather:NSArray!
    var fileManager:DJMFileManager?
    var isConnection:Bool = true
    
    
    /**************** load view ***************/
    override func viewDidLoad() {
        collectionWeatherView.delegate = self
        collectionWeatherView.dataSource = self
        fileManager = DJMFileManager.sharedFileManager()
        let table:NSArray = (WEATHER.list?.allObjects)!
        
        let descriptor = NSSortDescriptor(key: "dt_txt", ascending: true)
        self.dataWeather = table.sortedArrayUsingDescriptors([descriptor])
        self.showHeadDetailView()
        super.viewDidLoad()
       
    }
   
    
    /************ fun: for show header View in detail view ***********/
    func showHeadDetailView(){
        let weather = WEATHER.list?.allObjects[celluleSelected*8] as! DJMWeatherWithDate
         let mainTemp = weather.main
        headView.cityLabel.text = (WEATHER.city?.name)!+", latitude : "+(WEATHER.city?.coord!.lat?.stringValue)!+", longitude : "+(WEATHER.city?.coord!.lon?.stringValue)!
        headView.highLabel.text = "Today's High : "+self.getTemprerature((mainTemp?.temp_max)!)+"°"
        headView.lowLabel.text = "Today's Low : "+self.getTemprerature((mainTemp?.temp_min)!)+"°"
        headView.pressureLabel.text = "Pressure : "+(mainTemp?.pressure?.stringValue)!+" mbar"
        headView.humidityLabel.text =  "Humidity : "+(mainTemp?.humidity?.stringValue)!+"%"
        headView.windLabel.text = "Wind : "+(weather.wind?.speed?.stringValue)!+" m/s"
        self.dayLabel.text = day
    }
    
    func getTemprerature(temp:NSNumber)->(String){
        return NSString(format: "%.f", (Float(temp)-273.15)) as String
    }
    
    
    /******** build collection cellule **********/
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionID = "CollectionCellule"
        var index:Int=0
        if (celluleSelected == 0){
             index = (celluleSelected*8) + indexPath.row
        }else{
             index = ((celluleSelected*8) + indexPath.row)-(40-self.dataWeather.count)
        }
        let weather = dataWeather![index] as! DJMWeatherWithDate
        let detail = weather.weathers?.allObjects[0] as! DJMWeather
        let Cellule = collectionView.dequeueReusableCellWithReuseIdentifier(collectionID, forIndexPath: indexPath) as!DJMCollectionCellule
        Cellule.tempsLabel.text = self.getTemprerature((weather.main?.temp)!)+"°"
        Cellule.timeLabel.text = self.getHourFromDate(weather.dt_txt!)
        if (isConnection){
            let url = NSURL(string:"http://openweathermap.org/img/w/\(detail.icon!).png")
            let data =  NSData(contentsOfURL:url!)
            Cellule.imgCollection.image = UIImage(data: data!)
            let pathFile = fileManager!.fileInDocumentsDirectory(detail.icon!)
            fileManager!.saveImage(UIImage(data: data!)!, path: pathFile)
        }else{
            Cellule.imgCollection.image = fileManager!.loadImageFromPath(detail.icon!)
        }
        return Cellule
        
    }
    
   
    /***** format date : yyyy-MM-dd HH:mm:ss -> HH:mm *********/
    func getHourFromDate(val:String)->String{
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let todayDate = formatter.dateFromString(val)!
        formatter.dateFormat = "HH:mm"
        let dateString = formatter.stringFromDate(todayDate)
        return dateString
    }
    
    /***** return number of collection cellule ***************/
       func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(celluleSelected == 0){
            return (8 - (40-self.dataWeather.count))
        }else{
            return 8
        }
        
    }
}
