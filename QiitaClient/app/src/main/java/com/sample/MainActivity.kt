package com.sample

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ListView
import com.sample.model.Article
import com.sample.model.User
import com.sample.view.ArticleView

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val listAdapter = ArticleListAdapter(applicationContext)
        listAdapter.articles = listOf(
            dummyArticle("Kotlin入門", "momeemt"),
            dummyArticle("Java入門", "yakitorium")
        )

        val listView: ListView = findViewById(R.id.list_view) as ListView
        listView.adapter = listAdapter
    }

    private fun dummyArticle(title: String, userName: String): Article =
        Article(
            id = "",
            title = title,
            url = "https://kotlinlang.org",
            user = User(id = "", name = userName, profileImageUrl = "")
        )
}
