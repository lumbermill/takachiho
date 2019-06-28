package com.lumbermill.b_eater

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_score.*

class ScoreActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_score)

        val pref = applicationContext.getSharedPreferences("MyPref", 0)
        var score1 = pref.getInt("score1",-1)
        var score2 = pref.getInt("score2",-1)
        var score3 = pref.getInt("score3",-1)
        scoreText1.setText("Score : "+score1)
        scoreText2.setText("Score : "+score2)
        scoreText3.setText("Score : "+score3)
    }
}
