import UIKit
import FearKit

class ViewController: UIViewController {
    
    var cells: [Int] = [1,1,1,1,1,1,1,1,1,1,1]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .whiteColor()
        let tableView = FKFadingTableView(frame: self.view.frame, style: .Grouped)
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
//        delay(3.0) { () -> () in
//            self.cells.removeFirst()
//            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
//            delay(3.0) { () -> () in
//                self.cells.removeFirst()
//                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
//                delay(3.0) { () -> () in
//                    self.cells.removeFirst()
//                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
//                }
//            }
//        }
        
        delay(3.0) { () -> () in
            self.cells.append(1)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
            delay(3.0) { () -> () in
                self.cells.append(1)
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
                delay(3.0) { () -> () in
                    self.cells.append(1)
                    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bob") ?? UITableViewCell(style: .Value1, reuseIdentifier: "bob")
        cell.textLabel?.text = "TEST"
        cell.detailTextLabel?.text = "Detail"
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
}

