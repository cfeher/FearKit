import UIKit
import FearKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .whiteColor()
        let tableView = FKFadingTableView(frame: self.view.frame, style: .Grouped)
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bob") ?? UITableViewCell(style: .Value1, reuseIdentifier: "bob")
        cell.textLabel?.text = "TEST"
        cell.detailTextLabel?.text = "Detail"
        return cell
    }
}

