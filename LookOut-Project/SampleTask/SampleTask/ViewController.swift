//
//  ViewController.swift
//  SampleTask
//
//  Created by dinesh danda on 1/17/17.
//  Copyright © 2017 dinesh danda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var backTableView: UITableView!
    @IBOutlet weak var remindMeLaterButton: RoundedRectButton!
    @IBOutlet weak var resolvedButton: RoundedRectButton!
    var matchType = NSNumber()
    
    var dataFromJson = NSDictionary()
    
    @IBAction func reminderButtonTapped(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Reminder scheduled", message:
            "We’ll remind you about this alert tomorrow.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func resolvedButtonTapped(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Are you sure?", message:
            "Marking an alert as resolved means you will no longer be alerted on this leak and the alert will be removed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (UIAlertAction) in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.backTableView.register(UINib(nibName: "NotificationCustomCell", bundle: nil), forCellReuseIdentifier: "NotificationCustomCell")
        self.backTableView.register(UINib(nibName: "UserDetailsCustomCell", bundle: nil), forCellReuseIdentifier: "UserDetailsCustomCell")
        self.backTableView.register(UINib(nibName: "RiskDescriptionCell", bundle: nil), forCellReuseIdentifier: "RiskDescriptionCell")
        self.backTableView.register(UINib(nibName: "NextStepsCustomCell", bundle: nil), forCellReuseIdentifier: "NextStepsCustomCell")
        self.backTableView.register(UINib(nibName: "CustomButtonsCell", bundle: nil), forCellReuseIdentifier: "CustomButtonsCell")

        self.backTableView.separatorStyle = .none
        dataFromJson =  self.getDataFromJson()
        matchType = (dataFromJson.object(forKey: "type") as? NSNumber)!
        print(dataFromJson)
        self.backTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0,1,2,4:
            return 1
        case 3:
            return 3
        case 5:
            return 0
        default:
            return 1
        }
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCustomCell", for: indexPath) as! NotificationCustomCell
                if matchType == 1
                {
                    cell.titleLabel.text = "Identity Risk"
                    cell.subTitleLabel.text = "Your email has been leaked"
                }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsCustomCell", for: indexPath) as! UserDetailsCustomCell
            let detailsDict = dataFromJson.object(forKey: "events") as! [NSDictionary]
            let dataDictionary = detailsDict[0].object(forKey: "data") as! NSDictionary
            cell.emailIdLabel.text = dataDictionary.object(forKey: "email") as? String
            cell.fromLabel.text = "From: " +  (dataDictionary.object(forKey: "Source") as! String)
            let correctDate = (self.getDateInCorrectFormat(date: (dataDictionary.object(forKey: "CreationDate") as! NSString)))
            cell.dateLabel.text = "Date of leak:" +   ((correctDate) as String)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RiskDescriptionCell", for: indexPath) as! RiskDescriptionCell
            if matchType == 1
            {
                cell.descriptionLabel.text = "Your email and password were compromised and could be used to access other accounts"
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NextStepsCustomCell", for: indexPath) as! NextStepsCustomCell
            let rowIndex = indexPath.row
            switch rowIndex {
            case 0:
                cell.iconImage.image = UIImage.init(named: "Dots")
                cell.descriptionLabel.text = "Change your password immediately"
            case 1:
                cell.iconImage.image = UIImage.init(named: "Email Steps")
                cell.descriptionLabel.text = "Change password for any accounts that share this email and password combo"
            case 2:
                cell.iconImage.image = UIImage.init(named: "GraphSteps")
                cell.descriptionLabel.text = "Keep an eye on for any strange behavior"
            default:
                cell.iconImage.image = UIImage.init(named: "GraphSteps")

            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RiskDescriptionCell", for: indexPath) as! RiskDescriptionCell
            if matchType == 1
            {
                cell.descriptionLabel.text = "Talk to an export and get help with any issue related to identity protection"
            }
            return cell
        
        default:
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = indexPath.section
        switch section {
        case 0:
            return 74.0
        case 1:
            return 106.0
        case 2,4:
            return 66.0
        case 3:
            return 70.0
        case 5:
            return 44.0
        default:
            return 44.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0,1:
            return 0.0
        case 2,3,4,5:
            return 40.0
        default:
            return 44.0
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section {
        case 4,5:
            return 0.0
        
        default:
            return 1.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1.0))
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40.0))
        view.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 40))
        label.font = UIFont (name: "AvenirNext-DemiBold", size: 15)
        label.textColor = UIColor.darkGray
        view.addSubview(label)
        switch section {
        case 0:
            return nil
        case 1:
            return nil
        case 2:
            label.text = "What's at risk"
        case 3:
            label.text = "Next Steps"
        case 4:
            label.text = "Need help?"
        case 5:
            label.text = "Contact us now"
            label.textColor = UIColor.init(colorLiteralRed: 61.0/255.0, green: 178.0/255.0, blue: 73.0/255.0, alpha: 1.0)
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.contactUsTapped))
            tap.delegate = self
            view.addGestureRecognizer(tap)
        default:
            return nil
        }
        return view
    }
    
    func contactUsTapped(sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let alert = UIAlertController(title: "Contact us", message:
            "Call our experts for help.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Call", style: .default, handler: { (UIAlertAction) in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDataFromJson () -> NSDictionary
    {
        if let url = Bundle.main.url(forResource: "email-alert", withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
                    
                    return dictionary!
                } catch {
                    print("Error!! Unable to parse  email-alert.json")
                }
            }
            print("Error!! Unable to load  email-alert.json")
        }
        
        return NSDictionary()
    }
    
    func getDateInCorrectFormat (date:NSString) -> NSString{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let correctDate = dateFormatter.date(from: date as String)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: correctDate!)
        return dateString as NSString;
    }
}

