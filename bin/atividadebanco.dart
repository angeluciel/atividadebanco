import 'dart:io';

void main() {
  Library library = Library();

  while (true) {
    print('\n--- Biblioteca ---');
    print('1. Ver todos os títulos disponíveis');
    print('2. Retirar um livro');
    print('3. Devolver um livro');
    print('4. Adicionar livro ao acervo');
    print('5. Adicionar usuário');
    print('6. Relatório de livros emprestados');
    print('7. Sair');
    stdout.write('Escolha uma opção: ');

    String? choice = stdin.readLineSync();
    if (choice == null || choice.isEmpty) {
      print('Entrada inválida. Por favor, tente novamente.');
      continue;
    }

    switch (choice) {
      case '1':
        library.showBooks();
        break;
      case '2':
        library.borrowBook();
        break;
      case '3':
        library.returnBook();
        break;
      case '4':
        library.addBook();
        break;
      case '5':
        library.addUser();
        break;
      case '6':
        library.showBorrowedBooks();
        break;
      case '7':
        print('Obrigado por utilizar o sistema da biblioteca. Até logo!');
        exit(0);
      default:
        print('Opção inválida. Tente novamente.');
    }
  }
}

class Library {
  final List<Book> books = [];
  final List<User> users = [];

  void showBooks() {
    if (books.isEmpty) {
      print('Nenhum livro disponível no acervo.');
    } else {
      for (var book in books) {
        print('Título: ${book.title}, Autor: ${book.author}, Quantidade: ${book.quantity}, Status: ${book.isAvailable() ? "Disponível" : "Indisponível"}');
      }
    }
  }

  void borrowBook() {
    stdout.write('Digite o nome do usuário: ');
    String? userName = stdin.readLineSync();
    User? user = findUser(userName);

    if (user == null) {
      print('Usuário não encontrado.');
      return;
    }

    stdout.write('Digite o título do livro: ');
    String? bookTitle = stdin.readLineSync();
    Book? book = findBook(bookTitle);

    if (book == null) {
      print('Livro não encontrado.');
      return;
    }

    if (book.isAvailable()) {
      book.borrow();
      user.borrowedBooks.add(book);
      print('Livro "${book.title}" retirado com sucesso por ${user.name}.');
    } else {
      print('Livro "${book.title}" indisponível.');
    }
  }

  void returnBook() {
    stdout.write('Digite o nome do usuário: ');
    String? userName = stdin.readLineSync();
    User? user = findUser(userName);

    if (user == null) {
      print('Usuário não encontrado.');
      return;
    }

    stdout.write('Digite o título do livro: ');
    String? bookTitle = stdin.readLineSync();
    Book? book = findBook(bookTitle);

    if (book == null || !user.borrowedBooks.contains(book)) {
      print('Livro não encontrado entre os livros emprestados por este usuário.');
      return;
    }

    book.returnBook();
    user.borrowedBooks.remove(book);
    print('Livro "${book.title}" devolvido com sucesso.');
  }

  void addBook() {
    stdout.write('Digite o título do livro: ');
    String? title = stdin.readLineSync();
    stdout.write('Digite o nome do autor: ');
    String? author = stdin.readLineSync();
    stdout.write('Digite a quantidade de exemplares: ');
    int? quantity = int.tryParse(stdin.readLineSync() ?? '');

    if (title == null || title.isEmpty || author == null || author.isEmpty || quantity == null || quantity <= 0) {
      print('Dados inválidos. Tente novamente.');
      return;
    }

    books.add(Book(title: title, author: author, quantity: quantity));
    print('Livro "$title" adicionado ao acervo com sucesso.');
  }

  void addUser() {
    stdout.write('Digite o nome do usuário: ');
    String? name = stdin.readLineSync();

    if (name == null || name.isEmpty) {
      print('Nome do usuário não pode ser vazio.');
      return;
    }

    users.add(User(name: name));
    print('Usuário "$name" cadastrado com sucesso.');
  }

  void showBorrowedBooks() {
    bool hasBorrowedBooks = false;
    for (var user in users) {
      if (user.borrowedBooks.isNotEmpty) {
        hasBorrowedBooks = true;
        print('\nUsuário: ${user.name}');
        for (var book in user.borrowedBooks) {
          print('  - Livro: ${book.title}, Autor: ${book.author}');
        }
      }
    }
    if (!hasBorrowedBooks) {
      print('Nenhum livro emprestado no momento.');
    }
  }

  Book? findBook(String? title) {
    if (title == null || title.isEmpty) {
      return null;
    }

    for (var book in books) {
      if (book.title.toLowerCase() == title.toLowerCase()) {
        return book;
      }
    }
    return null;
  }

  User? findUser(String? name) {
    if (name == null || name.isEmpty) {
      return null;
    }

    for (var user in users) {
      if (user.name.toLowerCase() == name.toLowerCase()) {
        return user;
      }
    }
    return null;
  }
}

class Book {
  final String title;
  final String author;
  int quantity;

  Book({required this.title, required this.author, required this.quantity});

  bool isAvailable() {
    return quantity > 0;
  }

  void borrow() {
    if (isAvailable()) {
      quantity -= 1;
    }
  }

  void returnBook() {
    quantity += 1;
  }
}

class User {
  final String name;
  final List<Book> borrowedBooks = [];

  User({required this.name});
}
