import SwiftUI
import UIKit
import WebKit
import iamport_ios

struct PaymentBridge: UIViewControllerRepresentable {
    let paymentData: IamportPayment
    let onFinish: (IamportResponse?) -> Void
    
    func makeUIViewController(context: Context) -> PaymentViewController {
        let view = PaymentViewController()
        view.paymentData = self.paymentData
        view.onFinish = self.onFinish
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class PaymentViewController: UIViewController {
    // 주입받을 변수들
    var paymentData: IamportPayment?
    var onFinish: ((IamportResponse?) -> Void)?
    
    private var isPaymentRequested = false
    
    // 로딩 인디케이터 추가
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isPaymentRequested {
            isPaymentRequested = true
            requestPayment()
            
            // 결제 요청 시작 시 로딩 시작
            startLoading()
            requestPayment()
        }
    }
    
    private func requestPayment() {
        guard let paymentData = paymentData else {
            print("결제 데이터가 없습니다.")
            return
        }
        
        let userCode = "imp14511373" // 가맹점 식별코드
        
        Iamport.shared.useNavigationButton(enable: false)
        
        // 주입받은 paymentData 사용
        Iamport.shared.payment(
            viewController: self,
            userCode: userCode,
            payment: paymentData
        ) { [weak self] response in
            self?.onFinish?(response)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Logic
    private func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
}
