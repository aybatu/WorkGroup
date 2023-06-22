import Network

class Reachability {
    private let monitor = NWPathMonitor()
    private var isMonitoring = false
    
    var isNetworkAvailable: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    var connectionStatusChangedHandler: ((Bool) -> Void)?
    
    init() {
        setupPathUpdateHandler()
    }
    
    private func setupPathUpdateHandler() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                // Internet connection is available
                self?.connectionStatusChangedHandler?(true)
            } else {
                // Internet connection is not available
                self?.connectionStatusChangedHandler?(false)
            }
        }
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor.start(queue: DispatchQueue.global())
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        
        monitor.cancel()
        isMonitoring = false
    }
}
