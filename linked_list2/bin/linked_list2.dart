import 'dart:io'; // Import library untuk input/output
import 'dart:async';
import 'dart:math'; // Untuk random

class Node {
  String? data;
  Node? next;

  Node(this.data);
}

Future<void> delay(int milliseconds) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
}

void moveTo(int row, int col) {
  stdout.write('\x1B[${row};${col}H');
}

getScreenSize() {
  return [stdout.terminalColumns, stdout.terminalLines];
}

void clearScreen() {
  print("\x1B[2J\x1B[0;0H"); // clear entire screen, move cursor to 0;0
}

// Fungsi untuk memasukkan node baru ke posisi paling akhir atau awal
Node insertNode(Node head, Node newNode, bool isEnd) {
  if (!isEnd) {
    newNode.next = head;
    return newNode;
  }

  Node? currentNode = head;
  while (currentNode!.next != null) {
    currentNode = currentNode.next;
  }
  currentNode.next = newNode;
  return head;
}

// Fungsi untuk membuat loop pada linked list
void createLoop(Node head) {
  Node? currentNode = head;
  while (currentNode!.next != null) {
    currentNode = currentNode.next;
  }
  currentNode.next = head;
}

// Fungsi untuk membuat linked list dari input user
Node buildLinkedList(String input) {
  Node head = Node(input[0]);
  for (int i = 1; i < input.length; i++) {
    head = insertNode(head, Node(input[i]), true);
  }
  createLoop(head);
  return head;
}

// Fungsi untuk mendapatkan kode warna ANSI secara acak
String getRandomColor() {
  List<String> colors = [
    '\x1B[31m', // Merah
    '\x1B[32m', // Hijau
    '\x1B[33m', // Kuning
    '\x1B[34m', // Biru
    '\x1B[35m', // Ungu
    '\x1B[36m', // Cyan
    '\x1B[91m', // Merah terang
    '\x1B[92m', // Hijau terang
    '\x1B[93m', // Kuning terang
    '\x1B[94m', // Biru terang
    '\x1B[95m', // Ungu terang
    '\x1B[96m', // Cyan terang
    '\x1B[97m', // Putih terang
    '\x1B[90m', // Abu-abu
    '\x1B[37m', // Putih
    '\x1B[30m', // Hitam
  ];
  return colors[Random().nextInt(colors.length)];
}

// Fungsi untuk mencetak baris secara dinamis dengan arah yang bervariasi
Future<void> printRow(Node node, int row, int cols, bool reverse) async {
  String color = getRandomColor();
  if (!reverse) {
    for (int col = 1; col <= cols; col++) {
      moveTo(row, col);
      stdout.write(color + node.data! + '\x1B[0m');
      node = node.next!;
      await delay(10);
    }
  } else {
    for (int col = cols; col > 0; col--) {
      moveTo(row, col);
      stdout.write(color + node.data! + '\x1B[0m');
      node = node.next!;
      await delay(10);
    }
  }
}

void main() async {
  stdout.write("Masukkan teks untuk animasi: ");
  String? input = stdin.readLineSync();
  
  if (input == null || input.isEmpty) {
    print("Input tidak valid. Keluar dari program.");
    return;
  }

  Node head = buildLinkedList(input);
  clearScreen();
  List<int> screenSize = getScreenSize();
  
  Node? node = head;
  for (int row = 1; row <= screenSize[1]; row++) {
    await printRow(node!, row, screenSize[0], row % 2 == 0);
    node = node.next;
  }
}
