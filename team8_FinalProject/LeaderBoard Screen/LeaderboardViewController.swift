//
//  LeaderboardViewController.swift
//

import UIKit
import Firebase
import FirebaseFirestore

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let leaderboardView = LeaderboardView()
    private var leaderboardEntries: [LeaderboardEntry] = []

    override func loadView() {
        view = leaderboardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchLeaderboardData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchLeaderboardData()
    }

    private func setupTableView() {
        leaderboardView.leaderboardTableView.dataSource = self
        leaderboardView.leaderboardTableView.delegate = self
        leaderboardView.leaderboardTableView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
        leaderboardView.leaderboardTableView.separatorStyle = .none
    }

    private func fetchLeaderboardData() {
        let db = Firestore.firestore()
        
        db.collection("users")
            .order(by: "score", descending: true)
            .limit(to: 10)
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error fetching leaderboard data: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No leaderboard data found")
                    return
                }
                
                var entries: [LeaderboardEntry] = []
                var lastScore: Int? = nil
                var currentRank = 0
                var actualRank = 0
                
                for document in documents {
                    if let user = try? document.data(as: User.self) {
                        actualRank += 1

                        if user.score != lastScore {
                            currentRank = actualRank
                            lastScore = user.score
                        }
                        
                        entries.append(LeaderboardEntry(username: user.userName, score: user.score, rank: currentRank))
                    }
                }
                
                self?.leaderboardEntries = entries
                DispatchQueue.main.async {
                    self?.leaderboardView.leaderboardTableView.reloadData()
                }
            }
    }


    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as? LeaderboardCell else {
            return UITableViewCell()
        }
        
        let entry = leaderboardEntries[indexPath.row]
        cell.configure(rank: entry.rank, name: entry.username, score: entry.score)
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
