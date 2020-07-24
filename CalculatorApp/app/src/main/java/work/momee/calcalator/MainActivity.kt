package work.momee.calcalator

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        var displayNumberTextView = findViewById<TextView>(R.id.display_number)

        var oneButton = findViewById<Button>(R.id.one_button)
        var twoButton = findViewById<Button>(R.id.two_button)
        var threeButton = findViewById<Button>(R.id.three_button)

        oneButton.setOnClickListener {
            displayNumberTextView.text = getAdditionalTextDigits(displayNumberTextView, 1)
        }

        twoButton.setOnClickListener {
            displayNumberTextView.text = getAdditionalTextDigits(displayNumberTextView, 2)
        }

        threeButton.setOnClickListener {
            displayNumberTextView.text = getAdditionalTextDigits(displayNumberTextView
                , 3)
        }
    }

    private fun getAdditionalTextDigits(textView: TextView, addNumber: Int) : String  {
        val displayNumber = textView.text.toString().toInt()
        return (displayNumber * 10 + addNumber).toString()
    }

}
