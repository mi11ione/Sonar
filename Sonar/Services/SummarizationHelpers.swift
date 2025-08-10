import Foundation
import NaturalLanguage

enum SentenceSplitter {
    static func split(_ text: String) -> [String] {
        guard !text.isEmpty else { return [] }
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex ..< text.endIndex) { range, _ in
            let s = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !s.isEmpty { sentences.append(s) }
            return true
        }
        return sentences
    }
}

enum VectorOps {
    static func centroid(of vectors: [[Double]]) -> [Double] {
        guard let count = vectors.first?.count, !vectors.isEmpty else { return [] }
        var sum = Array(repeating: 0.0, count: count)
        for vector in vectors {
            for i in 0 ..< count {
                sum[i] += vector[i]
            }
        }
        return sum.map { $0 / Double(vectors.count) }
    }

    static func cosine(_ a: [Double], _ b: [Double]) -> Double {
        guard a.count == b.count, !a.isEmpty else { return 0 }
        var dot = 0.0
        var na = 0.0
        var nb = 0.0
        for i in 0 ..< a.count {
            dot += a[i] * b[i]
            na += a[i] * a[i]
            nb += b[i] * b[i]
        }
        let denom = (sqrt(na) * sqrt(nb))
        return denom == 0 ? 0 : dot / denom
    }
}

enum Rewriter {
    static func rewrite(_ text: String, toneHint _: String?) -> String {
        text.replacingOccurrences(of: "  ", with: " ")
    }
}
