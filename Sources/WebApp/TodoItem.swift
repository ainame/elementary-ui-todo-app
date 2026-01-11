import Foundation

final class TodoItem: Identifiable {
  let id: Int
  var title: String
  var description: String
  var deadline: String
  let createdAt: Date
  var updatedAt: Date

  init(
      id: Int,
      title: String,
      description: String,
      deadline: String,
      createdAt: Date,
      updatedAt: Date,
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.deadline = deadline
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}