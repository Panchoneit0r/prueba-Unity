using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Correr : MonoBehaviour
{
    public float speed = 3;
    private int carril = 1;
    void Update()
    {
        transform.Translate(Vector3.forward * Time.deltaTime * speed, Space.World);
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
            transform.position = new Vector3(45, transform.position.y, transform.position.z);
        }
        else if (carril == 1) {
            transform.position = new Vector3(47.5f, transform.position.y, transform.position.z);
        }
        else if (carril == 2) {
            transform.position = new Vector3(50, transform.position.y, transform.position.z);
        }
    }
}
