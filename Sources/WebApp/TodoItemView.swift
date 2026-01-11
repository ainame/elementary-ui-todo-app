import ElementaryUI

@View
struct TodoItemView {
  let item: TodoItem
  let onDelete: () -> Void

  @State var isEditMode: Bool = false

  var body: some View {
    div(
      .class(
        "bg-white rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 border-l-4 border-blue-500"
      )
    ) {
      if isEditMode {
        TodoItemEditView(
          item: item,
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
  let item: TodoItem
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
        .onClick { onCancel() }

        button(.class("bg-blue-600 hover:bg-blue-700 text-white font-medium text-sm px-3 py-1 rounded transition-colors")) {
          "Done"
        }
        .onClick { onSave() }
      }
    }
  }

  var editForm: some View {
    div(.class("space-y-4")) {
      form {
        titleField
        descriptionField
        deadlineField
      }
    }
  }

  var titleField: some View {
    label(.class("block text-sm font-medium text-gray-700 mb-1")) {
      "Title"

      input(.type(.text), .id("todo-id"), .class("w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"))
        .bindValue(#Binding(item.title))
    }
  }

  var descriptionField: some View {
    label(.class("block text-sm font-medium text-gray-700 mb-1")) {
      "Description"

      textarea(.id("todo-desc"), .class("w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 min-h-24")) {
        item.description
      }
      .onInput { event in
        if let value = event.targetValue {
          item.description = value
        }
      }
    }
  }

  var deadlineField: some View {
    label(.class("block text-sm font-medium text-gray-700 mb-1")) {
      "Deadline"

      input(.type(.date), .id("todo-deadline"), .class("w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"))
        .bindValue(#Binding(item.deadline))
    }
  }
}
