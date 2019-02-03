package sample

fun main(args:Array<String>){
  val x:Int = 2
  val output:String = when(x){
    1 -> "one"
    2,3 -> "two or three"
    else ->{
      "unknown"
    }
  }
  println(output)
}
