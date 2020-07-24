package com.sample

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ListView
import com.google.gson.FieldNamingPolicy
import com.google.gson.GsonBuilder
import com.sample.client.ArticleClient
import com.sample.model.Article
import com.sample.model.User
import com.sample.view.ArticleView
import retrofit2.Retrofit
import retrofit2.adapter.rxjava.RxJavaCallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory

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
        listView.setOnItemClickListener {
            adapterView, view, position, id ->
            val article = listAdapter.articles[position]
            ArticleActivity.intent(this, article).let { startActivity(it) }
        }

        val gson = GsonBuilder()
            .setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES)
            .create()

        val retrofit = Retrofit
            .Builder()
            .baseUrl("https:qiita.com")
            .addConverterFactory(GsonConverterFactory.create(gson))
            .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
            .build()

        val articleClient = retrofit.create(ArticleClient::class.java)
    }

    private fun dummyArticle(title: String, userName: String): Article =
        Article(
            id = "",
            title = title,
            url = "https://kotlinlang.org",
            user = User(id = "", name = userName, profileImageUrl = "")
        )
}
