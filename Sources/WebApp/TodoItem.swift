final class TodoItem: Identifiable {
    let id: Int
    var title: String
    var description: String
    var deadline: String

    init(id: Int, title: String, description: String, deadline: String) {
        self.id = id
        self.title = title
        self.description = description
        self.deadline = deadline
    }
}
