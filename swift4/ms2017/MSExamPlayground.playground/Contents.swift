//: Playground - noun: a place where people can play

import Cocoa

func FindSolutionNumber(n:Int, i:Int = 1) -> Int {
    if n == 0 {
        return 1
    }
    // see : if n >= i, we may find the ascending order items
    if n < i {
        return 0
    }
    let base = Int(sqrt(Double(n)))
    var count = 0
    // see: https://www.weheartswift.com/loops/
    for j in stride(from: i, to: base+1, by: 1) {
        count += FindSolutionNumber(n:n - j*j, i:j)
    }
    return count
}

func FindSolution(n:Int, i:Int = 1, prefix: Array<Int> = []) -> Int {
    if n == 0 {
        print("\nFind one solution: \(prefix.map{$0 * $0})")
        return 1
    }
    // see : if n >= i, we may find the ascending order items
    if n < i {
        return 0
    }
    let base = Int(sqrt(Double(n)))
    var count = 0
    // see: https://www.weheartswift.com/loops/
    for j in stride(from: i, to: base+1, by: 1) {
        // see : copy solution prefix, refer to https://stackoverflow.com/questions/25146382/how-do-i-concatenate-or-merge-arrays-in-swift
        var _prefix = prefix
        _prefix.append(j)
        let ret = FindSolution(n:n - j*j, i:j, prefix: _prefix)
        if ret > 0 {
            count += ret
        }
    }
    return count
}

print("********************************Find Solution***************************************")
for i in 5...10 {
    print(String(format:"\nFindSolution(n:%d) = %d", i, FindSolution(n: i)))
}

print("********************************Find Solution Number Only***************************************")
let n = 100
print(String(format:"\nFindSolutionNumber(n:%d) = %d", n, FindSolutionNumber(n: n)))

