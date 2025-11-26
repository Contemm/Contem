import SwiftUI
import UIKit
import WebKit
import iamport_ios

//struct PaymentView: View {
//    @StateObject private var viewModel: PaymentViewModel
//
//    init(coordinator: AppCoordinator) {
//        _viewModel = StateObject(wrappedValue: PaymentViewModel(coordinator: coordinator))
//    }
//
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}



//// 예제 코드
//struct PaymentTestView: UIViewControllerRepresentable {
//    @EnvironmentObject var viewModel: PaymentViewModel
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let view = PaymentViewController()
//        view.viewModel = viewModel
//        return view
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
//}
//
//final class PaymentViewController: UIViewController, WKNavigationDelegate {
//    var viewModel: PaymentViewModel? = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("PaymentView viewDidLoad")
//
//        view.backgroundColor = UIColor.white
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("PaymentView viewDidAppear")
//        requestPayment()
//    }
//
//
//    func requestPayment() {
//        guard let viewModel = viewModel else {
//            print("viewModel 이 존재하지 않습니다.")
//            return
//        }
//
//        let userCode = viewModel.order.userCode // iamport 에서 부여받은 가맹점 식별코드
//        if let payment = viewModel.createPaymentData() {
//            dump(payment)
//
//            //          #case1 use for UIViewController
//            //          WebViewController 용 닫기버튼 생성(PG "uplus(토스페이먼츠 구모듈)"는 자체취소 버튼이 없는 것으로 보임)
//            Iamport.shared.useNavigationButton(enable: true)
//
//            Iamport.shared.payment(viewController: self,
//                                   userCode: userCode.value, payment: payment) { response in
//                viewModel.iamportCallback(response)
//            }
//
//            //          #case2 use for navigationController
//            //          guard let navController = navigationController else {
//            //              print("navigationController 를 찾을 수 없습니다")
//            //              return
//            //          }
//            //
//            //          Iamport.shared.payment(navController: navController,
//            //              userCode: userCode.value, iamportRequest: request) { iamportResponse in
//            //              viewModel.iamportCallback(iamportResponse)
//            //          }
//        }
//    }
//
//}



//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isPaymentRequested {
            isPaymentRequested = true
            requestPayment()
        }
    }
    
    private func requestPayment() {
        guard let paymentData = paymentData else {
            print("결제 데이터가 없습니다.")
            return
        }
        
        let userCode = "iamport" // 가맹점 식별코드
        
        Iamport.shared.useNavigationButton(enable: true)
        
        // 주입받은 paymentData 사용
        Iamport.shared.payment(
            viewController: self,
            userCode: userCode,
            payment: paymentData
        ) { [weak self] response in
            self?.onFinish?(response)
        }
    }
}
