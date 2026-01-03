var view = UIView()
view.frame = CGRect(x: 0, y: 0, width: 430, height: 932)
var shadows = UIView()
shadows.frame = view.frame
shadows.clipsToBounds = false
view.addSubview(shadows)

let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 30)
let layer0 = CALayer()
layer0.shadowPath = shadowPath0.cgPath
layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
layer0.shadowOpacity = 1
layer0.shadowRadius = 60
layer0.shadowOffset = CGSize(width: 0, height: 30)
layer0.bounds = shadows.bounds
layer0.position = shadows.center
shadows.layer.addSublayer(layer0)

var shapes = UIView()
shapes.frame = view.frame
shapes.clipsToBounds = true
view.addSubview(shapes)

let layer1 = CALayer()
layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
layer1.bounds = shapes.bounds
layer1.position = shapes.center
shapes.layer.addSublayer(layer1)

shapes.layer.cornerRadius = 30


view = UIView()
view.frame = CGRect(x: 0, y: 0, width: 430, height: 932)
shadows = UIView()
shadows.frame = view.frame
shadows.clipsToBounds = false
view.addSubview(shadows)

let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 30)
let layer0 = CALayer()
layer0.shadowPath = shadowPath0.cgPath
layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
layer0.shadowOpacity = 1
layer0.shadowRadius = 60
layer0.shadowOffset = CGSize(width: 0, height: 30)
layer0.bounds = shadows.bounds
layer0.position = shadows.center
shadows.layer.addSublayer(layer0)

shapes = UIView()
shapes.frame = view.frame
shapes.clipsToBounds = true
view.addSubview(shapes)

let layer1 = CALayer()
layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
layer1.bounds = shapes.bounds
layer1.position = shapes.center
shapes.layer.addSublayer(layer1)

shapes.layer.cornerRadius = 30


view = UIView()
view.frame = CGRect(x: 0, y: 0, width: 430, height: 932)
shadows = UIView()
shadows.frame = view.frame
shadows.clipsToBounds = false
view.addSubview(shadows)

let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 30)
let layer0 = CALayer()
layer0.shadowPath = shadowPath0.cgPath
layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
layer0.shadowOpacity = 1
layer0.shadowRadius = 60
layer0.shadowOffset = CGSize(width: 0, height: 30)
layer0.bounds = shadows.bounds
layer0.position = shadows.center
shadows.layer.addSublayer(layer0)

shapes = UIView()
shapes.frame = view.frame
shapes.clipsToBounds = true
view.addSubview(shapes)

let layer1 = CALayer()
layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
layer1.bounds = shapes.bounds
layer1.position = shapes.center
shapes.layer.addSublayer(layer1)

shapes.layer.cornerRadius = 30






