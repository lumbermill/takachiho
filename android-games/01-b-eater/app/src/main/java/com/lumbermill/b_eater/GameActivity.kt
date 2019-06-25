package com.lumbermill.b_eater

import android.content.Intent
import android.graphics.drawable.AnimationDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.widget.ImageView
import android.widget.Toast
import kotlin.random.Random
import android.media.MediaPlayer
import androidx.appcompat.app.AlertDialog
import kotlinx.android.synthetic.main.activity_game.*


class GameActivity : AppCompatActivity() {
    private lateinit var sonAnimation: AnimationDrawable
    private lateinit var fatherAnimation: AnimationDrawable
    var randomValues: Long = 0
    var mediaPlayer: MediaPlayer? = null
    var score = 0
    var flag = 0

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_game)

        val sonImage = findViewById<ImageView>(R.id.sonid).apply {
            setBackgroundResource(R.drawable.son)
            sonAnimation = background as AnimationDrawable
        }


        val fatherImage = findViewById<ImageView>(R.id.fatherid).apply {
            setBackgroundResource(R.drawable.father)
            fatherAnimation = background as AnimationDrawable

        }

        startPlay.setOnClickListener {
            sonAnimation.start()
        }


        val h = Handler()
        h.postDelayed(object : Runnable {
            override fun run() {
                if (sonAnimation.current == sonAnimation.getFrame(2) && fatherAnimation.current == fatherAnimation.getFrame(
                        2
                    )
                ) {
                    sonAnimation.stop()
                    fatherAnimation.stop()
                    flag = 1
                    showDialog()

                }

                if (sonAnimation.current == sonAnimation.getFrame(1) && flag == 0) {
                    score += 1

                }
                if (flag == 0) {
                    h.postDelayed(this, 235)
                }

            }
        }, 235)

        stop.setOnClickListener {
            sonAnimation.stop()
        }


        val handler = Handler()
        handler.postDelayed(object : Runnable {
            override fun run() {
                randomValues = Random.nextLong(0, 10)
                if (flag == 0) {
                    fatherAnimation.start()
                    handler.postDelayed(this, (randomValues * 1000) + 970)
                }

            }
        }, 2000)


        val handler1 = Handler()
        handler1.postDelayed(object : Runnable {
            override fun run() {
                fatherAnimation.stop()
                handler1.postDelayed(this, (randomValues * 1000) + 1205)
            }
        }, 2970)


    }

    fun showDialog() {
        val builder = AlertDialog.Builder(this@GameActivity)
        builder.setTitle("Score")
        builder.setMessage("Your Score is: " + score)
        builder.setPositiveButton("Back") { dialog, which ->
            var i = Intent(this, HomeActivity::class.java)
            startActivity(i)
        }
        val dialog: AlertDialog = builder.create()
        dialog.show()
        score = 0
    }


}