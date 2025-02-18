// MARK: - Models
struct GitHubRepo {
    let name: String
    let commits: [String]
    let icon: UIImage
}

// MARK: - ViewController
class GitHubReposViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
    var repos: [GitHubRepo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMockData()
        
        title = "GITHUB"
        
        tableView.delegate = self
        tableView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        
        // Register cells
        tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: "RepoCell")
        carouselCollectionView.register(RepoCollectionViewCell.self, forCellWithReuseIdentifier: "CarouselCell")
    }
    
    private func setupUI() {
        // Setup pageControl
        pageControl.numberOfPages = repos.count
        pageControl.currentPage = 0
        
        // Setup collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 100)
        layout.minimumLineSpacing = 10
        carouselCollectionView.collectionViewLayout = layout
        
        // Setup table view
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
    }
    
    private func loadMockData() {
        // Add mock repositories
        repos = [
            GitHubRepo(name: "Github Repo Name", commits: ["Commit 1", "Commit 2", "Commit 3"], icon: UIImage(named: "repo-icon")!),
            GitHubRepo(name: "Github Repo Name", commits: ["Commit 1", "Commit 2"], icon: UIImage(named: "repo-icon")!),
            GitHubRepo(name: "Github Repo Name", commits: [], icon: UIImage(named: "repo-icon")!)
        ]
    }
}

// MARK: - UITableViewDelegate & DataSource
extension GitHubReposViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoTableViewCell
        let repo = repos[indexPath.row]
        cell.configure(with: repo)
        return cell
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension GitHubReposViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! RepoCollectionViewCell
        let repo = repos[indexPath.row]
        cell.configure(with: repo)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == carouselCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            pageControl.currentPage = page
        }
    }
}

// MARK: - Custom Cells
class RepoTableViewCell: UITableViewCell {
    private let repoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let commitsStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        // Setup image view
        repoImageView.contentMode = .scaleAspectFit
        repoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(repoImageView)
        
        // Setup name label
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        // Setup commits stack view
        commitsStackView.axis = .vertical
        commitsStackView.spacing = 4
        commitsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(commitsStackView)
        
        NSLayoutConstraint.activate([
            repoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            repoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            repoImageView.widthAnchor.constraint(equalToConstant: 40),
            repoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: repoImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            commitsStackView.leadingAnchor.constraint(equalTo: repoImageView.trailingAnchor, constant: 12),
            commitsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            commitsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with repo: GitHubRepo) {
        repoImageView.image = repo.icon
        nameLabel.text = repo.name
        
        // Clear existing commit labels
        commitsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add commit labels
        repo.commits.forEach { commit in
            let commitLabel = UILabel()
            commitLabel.text = commit
            commitLabel.font = .systemFont(ofSize: 14)
            commitLabel.textColor = .darkGray
            commitsStackView.addArrangedSubview(commitLabel)
        }
    }
}

class RepoCollectionViewCell: UICollectionViewCell {
    private let repoImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        
        // Setup image view
        repoImageView.contentMode = .scaleAspectFit
        repoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(repoImageView)
        
        // Setup name label
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            repoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            repoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            repoImageView.widthAnchor.constraint(equalToConstant: 40),
            repoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: repoImageView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with repo: GitHubRepo) {
        repoImageView.image = repo.icon
        nameLabel.text = repo.name
    }
}
