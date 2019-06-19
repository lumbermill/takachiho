package com.lumbermill.b_eater

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_home.*

class HomeActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)
        buttonPlay.setOnClickListener {
            var play = Intent(this, GameActivity::class.java)
            startActivity(play)
        }

        scoreButton.setOnClickListener {
            var play = Intent(this, ScoreActivity::class.java)
            startActivity(play)
        }
    }
}
