//: Playground - noun: a place where people can play

import Cocoa

/**
 * timing closure, refer to https://jjude.com/timeit/
 */
func Timing(fun: ()->Void) {
    let start = Date()
    fun()
    let end = Date()
    let timeInterval: Double = end.timeIntervalSince(start)
    print(String(format: "Time to execute %.2f seconds", timeInterval))
}

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

print("**************************Find Solution Number Only*********************************")
let n = 100
Timing {
    print(String(format:"\nFindSolutionNumber(n:%d) = %d", n, FindSolutionNumber(n: n)))
}

// see : https://stackoverflow.com/questions/24131323/in-swift-can-i-use-a-tuple-as-the-key-in-a-dictionary
struct Tuple<T:Hashable, U:Hashable> : Hashable {
    let values : (T, U)
    
    var hashValue : Int {
        get {
            let (a,b) = values
            return a.hashValue &* 31 &+ b.hashValue
        }
    }
    
    static func ==(lhs: Tuple<T, U>, rhs: Tuple<T, U>) -> Bool {
        return lhs.values == rhs.values
    }
}

/**
 * successful running case for swift 4.
 * see: reference in http://www.howtobuildsoftware.com/index.php/how-do/skV/swift-functional-programming-sum-of-fibonacci-term-using-functional-swift
func memoize<T:Hashable, U>( body: @escaping ((T)->U,T) -> U) -> (T)->U {
    var memo = [T:U]()
    var result: ((T)->U)!
    result = { x in
        if let q = memo[x] { return q }
        let r = body(result,x)
        memo[x] = r
        return r
    }
    return result
}
let fibonacciFunc = memoize { (fibonacci:(Int)->Int, n:Int) in n < 2 ? n : fibonacci(n-1) + fibonacci(n-2) }
print("fibonacci(50) = ", Int(fibonacciFunc(50)))
 */

/**
 * Dynamic Programming based on parameter-result-storing table.
 * refer to https://cocoacasts.com/what-do-escaping-and-noescaping-mean-in-swift-3/
 */
func memoize<T, U>( body: @escaping ((T, T)->U, T, T) ->U ) -> (T, T)->U {
    var memo = [String:U]()
    var result: ((T, T)->U)!
    result = { x, y in
        let key = String("\(x), \(y)")
        if let q = memo[key] { return q }
        let r = body(result, x, y)
        memo[key] = r
        return r
    }
    return result
}

// see also fibonacciFunc
let findsolOnlyNum = memoize {
    ( findsolNum: (Int, Int)->Int, n:Int, i: Int ) -> Int in
        if n == 0 {
            return 1
        }
        // see : if n >= i, we may find the ascending order items
        if n < i {
            return 0
        }
        let base = Int(sqrt(Double(n)))
        var count:Int = 0
        for j in stride(from: i, to: base+1, by: 1) {
            count += findsolNum(n - j*j, j)
        }
        return count
}

print("******************Find Solution Number Only (With DP Table)*************************")
Timing {
    print("findsolOnlyNum(n:100) = ", findsolOnlyNum(100, 1))
}

func memoize<T, U>( body: @escaping ((T, T, Array<Int>)->U, T, T, Array<Int>) ->U ) -> (T, T, Array<Int>)->U {
    var memo = [String:U]()
    var result: ((T, T, Array<Int>)->U)!
    result = { x, y, z in
        let key = String("\(x), \(y)")
        if let q = memo[key] { return q }
        let r = body(result, x, y, z)
        memo[key] = r
        return r
    }
    return result
}

let findsolWithAns = memoize {
    ( findsol: (Int, Int, Array<Int>)->Int, n: Int, i: Int, prefix: Array<Int> ) -> Int in
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
print("*********************Find Solution Number(With DP Table)****************************")
Timing {
    print("FindSolution(n:60) = ", FindSolution(n:60))
}
Timing {
    print("findsolWithAns(n:60) = ", findsolWithAns(60, 1, []))
}

