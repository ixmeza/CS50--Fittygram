import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var btnSepia: UIButton!
    @IBOutlet var btnNoir: UIButton!
    @IBOutlet var btnVintage: UIButton!
    @IBOutlet var btnHalftone: UIButton!
    @IBOutlet var btnReset: UIButton!
    @IBOutlet var btnBlurry: UIButton!

    let context = CIContext()
    var original: UIImage!
    
    override func viewDidLoad() {
        // image literal for the background
        let back =  #imageLiteral(resourceName: "back")
        //setting background with image in back
        self.view.backgroundColor = UIColor(patternImage: back)
        
        var btn = btnSepia
        prettier(btn:btn!)
        btn = btnNoir
        prettier(btn:btn!)
        btn = btnVintage
        prettier(btn:btn!)
        btn = btnHalftone
        prettier(btn:btn!)
        btn = btnReset
        prettier(btn:btn!)
        btn = btnBlurry
        prettier(btn:btn!)
    }
    
    func prettier(btn : UIButton){
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = btn.frame.height / 2
        btn.setTitleColor(UIColor.gray, for: UIControl.State.normal)
    }

    @IBAction func applySepia() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }

    @IBAction func applyNoir() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    @IBAction func applyVintage() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectProcess")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }
    
    @IBAction func applyBlurry(){
        if original == nil {
            return
        }
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        filter?.setValue(10, forKey: kCIInputRadiusKey)
        display(filter: filter!)
    }
    
    @IBAction func applyHalfTone(){
        if original == nil {
            return
        }
        let filter = CIFilter(name: "CICMYKHalftone")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        filter?.setValue(40, forKey: kCIInputWidthKey)
        display(filter: filter!)
    }
    @IBAction func applyReset(){
        if original == nil {
            return
        }
        imageView.image = original
    }
    
    @IBAction func choosePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.navigationController?.present(picker, animated: true, completion: nil)
        }
    }

    func display(filter: CIFilter) {
        let output = filter.outputImage!
        imageView.image = UIImage(cgImage: self.context.createCGImage(output, from: output.extent)!)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            original = image
        }
    }
    
    @IBAction func SavePhoto(_ sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!,self,#selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image saved to photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
