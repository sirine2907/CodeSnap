import 'package:codesnap/features/snippets/domain/entities/snippet.dart';
import 'package:codesnap/features/snippets/domain/entities/snippet_style.dart';

// Snippets used in tests and to render the README screenshots.

final pythonSnippet = Snippet(
  id: '1',
  title: 'fetch_users.py',
  language: 'python',
  style: const SnippetStyle(themeName: 'Night Owl', backgroundName: 'Ocean'),
  updatedAt: DateTime(2026, 10, 20, 18, 30),
  code: '''import requests

def fetch_users(page=1):
    """Get one page of users from the API."""
    url = f"https://api.example.com/users?page={page}"
    response = requests.get(url, timeout=5)
    response.raise_for_status()

    users = response.json()["data"]
    return [u["name"] for u in users if u["active"]]


print(fetch_users())''',
);

final typescriptSnippet = Snippet(
  id: '2',
  title: 'useDebounce.ts',
  language: 'typescript',
  style: const SnippetStyle(themeName: 'Dracula', backgroundName: 'Sunset'),
  updatedAt: DateTime(2026, 10, 19, 11),
  code: '''import { useEffect, useState } from "react";

export function useDebounce<T>(value: T, delay = 300): T {
  const [debounced, setDebounced] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);

  return debounced;
}''',
);

final goSnippet = Snippet(
  id: '3',
  title: 'main.go',
  language: 'go',
  style: const SnippetStyle(themeName: 'Nord', backgroundName: 'Forest'),
  updatedAt: DateTime(2026, 10, 17, 9),
  code: '''package main

import "fmt"

func main() {
    ch := make(chan int)
    go func() {
        for i := 1; i <= 3; i++ {
            ch <- i * i
        }
        close(ch)
    }()
    for n := range ch {
        fmt.Println(n)
    }
}''',
);

final sqlSnippet = Snippet(
  id: '4',
  title: 'top_customers.sql',
  language: 'sql',
  style: const SnippetStyle(themeName: 'GitHub', backgroundName: 'Snow'),
  updatedAt: DateTime(2026, 10, 15, 14),
  code: '''SELECT c.name, SUM(o.total) AS spent
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE o.created_at >= '2026-01-01'
GROUP BY c.name
ORDER BY spent DESC
LIMIT 10;''',
);

final cssSnippet = Snippet(
  id: '5',
  title: 'button.css',
  language: 'css',
  style: const SnippetStyle(themeName: 'Monokai', backgroundName: 'Candy'),
  updatedAt: DateTime(2026, 10, 12, 16),
  code: '''.button {
  padding: 12px 20px;
  border-radius: 999px;
  background: linear-gradient(135deg, #ff7eb3, #7c5cff);
  color: white;
  transition: transform 0.2s ease;
}

.button:hover {
  transform: translateY(-2px);
}''',
);

final rustSnippet = Snippet(
  id: '6',
  title: 'fib.rs',
  language: 'rust',
  style: const SnippetStyle(themeName: 'Gruvbox', backgroundName: 'Peach'),
  updatedAt: DateTime(2026, 10, 8, 10),
  code: '''fn fib(n: u64) -> u64 {
    match n {
        0 => 0,
        1 => 1,
        _ => fib(n - 1) + fib(n - 2),
    }
}

fn main() {
    println!("{}", fib(20));
}''',
);

final allSampleSnippets = [
  pythonSnippet,
  typescriptSnippet,
  goSnippet,
  sqlSnippet,
  cssSnippet,
  rustSnippet,
];
