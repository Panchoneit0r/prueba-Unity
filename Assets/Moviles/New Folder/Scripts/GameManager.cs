using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class GameManager : MonoBehaviour
{
    [Tooltip("Reference to the obstacle")]
    public Transform obstacle;   
    
    [Tooltip("A reference to the tile we want to spawn")]
    public Transform tile;

    [Tooltip("Where the first tile should be placed at")]
    public Vector3 startPoint = new Vector3(0, 0, -5);

    [Tooltip("How many tiles should we create in advance")]
    [Range(1, 15)]
    public int initSpawnNum = 10;
    
    [Tooltip("How many tiles before the first obstacle")]
    public int initNoObstacles = 4;
    
    /// <summary> 
    /// Where the next tile should be spawned at. 
    /// </summary> 
    private Vector3 _nextTileLocation;
    /// <summary> 
    /// How should the next tile be rotated? 
    /// </summary> 
    private Quaternion _nextTileRotation;
    /// <summary>
    /// Start is called before the first frame update
    /// </summary>
    
    private void Start()
    {
        // Set our starting point 
	    // Manage Rotation and Orientation
        _nextTileLocation = startPoint;
        _nextTileRotation = Quaternion.identity;
        for (int i = 0; i < initSpawnNum; ++i)
        {
            SpawnNextTile(i >= initNoObstacles);
        }
    }
    
    /// <summary> 
    /// Will spawn a tile at a certain location and setup the next
    /// position 
    /// </summary> 
    public void SpawnNextTile(bool spawnObstacle = true)
    {
        var newTile = Instantiate(tile, _nextTileLocation,
        _nextTileRotation);
        
        // Figure out where and at what rotation we should spawn
        // the next item 
        var nextTile = newTile.Find("Next Spawn Point");
        _nextTileLocation = nextTile.position;
        _nextTileRotation = nextTile.rotation;
        if (spawnObstacle)
        {
            Aparece(newTile);
        }
    }
    
    void Aparece(Transform newTile)
    {
        var obstaclesSpawnPoints = new List<GameObject>();
        foreach (Transform child in newTile)
        {
            if (child.CompareTag("ObstacleSpawn"))
            {
                obstaclesSpawnPoints.Add(child.gameObject);
            }
        }

        if (obstaclesSpawnPoints.Count > 0)
        {
            var spawnPoint = obstaclesSpawnPoints[Random.Range(0, obstaclesSpawnPoints.Count)];
            var spawnPos = spawnPoint.transform.position;
            var newObstacle = Instantiate(obstacle, spawnPos, Quaternion.identity);

            newObstacle.SetParent(spawnPoint.transform);
        }
    }
}
