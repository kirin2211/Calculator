//
//  File.swift
//  iOSCalculator
//
//  Created by Seo on 2023/07/06.
//

import Foundation

func multiply(op1 : Double, op2 : Double) -> Double{
    return op1 * op2
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand : Double){
        accumulator = operand
    }
    
    var operations : Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "+" : Operation.BinaryOperation(multiply),
        "-" : Operation.BinaryOperation(multiply),
        "×" : Operation.BinaryOperation(multiply),
        "÷" : Operation.BinaryOperation(multiply),
        "=" : Operation.Equals
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol : String){
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue) : accumulator = associatedConstantValue
            case .UnaryOperation(let function) : accumulator = function(accumulator)
            case .BinaryOperation(let function) :
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals :
                executePendingBinaryOperation()
            }
        }
//        if let constant = operations[symbol]{
//            accumulator = constant
//        }
//        switch symbol{
//            case "π" : accumulator = M_PI
//            case "√" : accumulator = sqrt(accumulator)
//        default : break
//        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction : (Double,Double) -> Double
        var firstOperand : Double
        
    }
    
    var result : Double{
        get {
            return accumulator
        }
        
    }
}
