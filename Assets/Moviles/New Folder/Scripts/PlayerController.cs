using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PlayerLoop;
using Update = Unity.VisualScripting.Update;

public class PlayerController : MonoBehaviour
{
     // A reference to the Rigidbody component 
    private Rigidbody rb;
    private int carril = 1;
    
    [Tooltip("How fast the ball moves left/right")]
    [Range(0, 10)]
    public float dodgeSpeed = 5;
    
    [Tooltip("How fast the ball moves forwards automatically")]
    [Range(0, 10)]
    public float rollSpeed = 5;

    // Start is called before the first frame update
    void Start()
    {
        // Get access to our Rigidbody component 
        rb = GetComponent<Rigidbody>();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.A)) {
            carril--;
            if (carril == -1) {
                carril = 0;
            }
        }
        if (Input.GetKeyDown(KeyCode.D)) {
            carril++;
            if (carril == 3) {
                carril = 2;
            }
        }

        if (carril == 0) {
            transform.position = new Vector3(-1.8f, transform.position.y, transform.position.z);
        }
        else if (carril == 1) {
            transform.position = new Vector3(0, transform.position.y, transform.position.z);
        }
        else if (carril == 2) {
            transform.position = new Vector3(1.8f, transform.position.y, transform.position.z);
        }
    }

    /// <summary>
    /// FixedUpdate is called at a fixed framerate and is a prime place to put
    /// Anything based on time.
    /// </summary>
    private void FixedUpdate()
    {
        // Check if we're moving to the side 
        var horizontalSpeed = Input.GetAxis("Horizontal") * dodgeSpeed;
        rb.AddForce(horizontalSpeed, 0, rollSpeed);
    }
}