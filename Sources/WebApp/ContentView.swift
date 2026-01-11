import ElementaryUI
import Reactivity

@Reactive
final class TodoItem: Identifiable {
    let id: String
    var title: String
    var description: String
    var deadline: String

    init(id: Int, title: String, description: String, deadline: String) {
        self.id = "\(id)"
        self.title = title
        self.description = description
        self.deadline = deadline
    }
}

@View
struct ContentView {
    @State var count: Int = 0
    @State var nextId: Int = 0
    @State var items: [TodoItem] = []

    var body: some View {
        div(.class("max-w-3xl mx-auto p-8")) {
            div(.class("mb-8")) {
                h1(.class("text-4xl font-bold text-gray-900 mb-2")) {
                    "✨ My Todo List"
                }

                p(.class("text-gray-600 mb-6")) {
                    "Stay organized and get things done"
                }
            }

            button(.class("bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white font-bold px-6 py-3 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 mb-8 w-full")) {
                "➕ Add New Todo"
            }
            .onClick {
                createTodoItem()
            }

            div(.class("space-y-4")) {
                ForEach(items, key: { $0.id }) { item in
                    TodoItemView(
                        item: #Binding(item),
                        onDelete: { deleteItem(item) }
                    )
                }
            }
        }
        .animateContainerLayout()
        .animation(.smooth, value: count)
    }

    func createTodoItem() {
        items.append(
            TodoItem(
                id: nextId,
                title: "Title",
                description: "Description",
                deadline: "2026-01-15"
            )
        )
        nextId += 1
    }

    func deleteItem(_ item: TodoItem) {
        items.removeAll { $0.id == item.id }
    }
}

@View
struct TodoItemView {
    @Binding var item: TodoItem
    let onDelete: () -> Void

    @State var isEditMode: Bool = false

    var body: some View {
        div(.class("bg-white rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 border-l-4 border-blue-500")) {
            if isEditMode {
                TodoItemEditView(
                    title: $item.title,
                    description: $item.description,
                    deadline: $item.deadline,
                    onCancel: { isEditMode = false },
                    onSave: { isEditMode = false }
                )
            } else {
                TodoItemViewerView(
                    item: item,
                    onEdit: { isEditMode = true },
                    onDelete: onDelete
                )
            }
        }
    }
}

@View
struct TodoItemViewerView {
    let item: TodoItem
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        div {
            // Header with title and action buttons
            div(.class("flex items-center justify-between mb-3")) {
                div(.class("flex items-center gap-3")) {
                    span(.class("text-2xl")) {
                        "📌"
                    }
                    h3(.class("text-xl font-bold text-gray-900")) {
                        item.title
                    }
                }

                div(.class("flex gap-2")) {
                    button(.class("text-red-600 hover:text-red-700 font-medium text-sm px-3 py-1 rounded hover:bg-red-50 transition-colors")) {
                        "Delete"
                    }
                    .onClick {
                        onDelete()
                    }

                    button(.class("text-blue-600 hover:text-blue-700 font-medium text-sm px-3 py-1 rounded hover:bg-blue-50 transition-colors")) {
                        "Edit"
                    }
                    .onClick {
                        onEdit()
                    }
                }
            }

            p(.class("text-gray-600 text-base leading-relaxed mb-4 ml-11")) {
                item.description
            }

            div(.class("flex items-center gap-2 ml-11")) {
                span(.class("text-sm")) {
                    "🗓️"
                }
                span(.class("text-sm font-medium text-blue-600")) {
                    item.deadline
                }
            }
        }
    }
}

@View
struct TodoItemEditView {
    @Binding var title: String
    @Binding var description: String
    @Binding var deadline: String
    let onCancel: () -> Void
    let onSave: () -> Void

    var body: some View {
        div {
            editHeader
            editForm
        }
    }

    var editHeader: some View {
        div(.class("flex items-center justify-between mb-4")) {
            h3(.class("text-xl font-bold text-gray-900")) {
                "Edit Todo"
            }

            div(.class("flex gap-2")) {
                button(.class("text-gray-600 hover:text-gray-700 font-medium text-sm px-3 py-1 rounded hover:bg-gray-100 transition-colors")) {
                    "Cancel"
                }
                .onClick {
                    onCancel()
                }

                button(.class("bg-blue-600 hover:bg-blue-700 text-white font-medium text-sm px-3 py-1 rounded transition-colors")) {
                    "Done"
                }
                .onClick {
                    onSave()
                }
            }
        }
    }

    var editForm: some View {
        div(.class("space-y-4")) {
            titleField
            descriptionField
            deadlineField
        }
    }

    var titleField: some View {
        div {
            label(.class("block text-sm font-medium text-gray-700 mb-1")) {
                "Title"
            }
            input(
                .class("w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"),
                .type(.text)
            )
            .bindValue($title)
        }
    }

    var descriptionField: some View {
        div {
            label(.class("block text-sm font-medium text-gray-700 mb-1")) {
                "Description"
            }
            textarea(
                .class("w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 min-h-24")
            ) {
                description
            }
            .onInput { event in
                if let value = event.targetValue {
                    description = value
                }
            }
        }
    }

    var deadlineField: some View {
        div {
            label(.class("block text-sm font-medium text-gray-700 mb-1")) {
                "Deadline"
            }
            input(
                .class("w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"),
                .type(.date)
            )
            .bindValue($deadline)
        }
    }
}
