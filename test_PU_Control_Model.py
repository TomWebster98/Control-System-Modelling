import unittest
from PU_Control_Model import PowerUnitModel, MODES
# from parameterized import parameterized


class TestPowerUnitModel(unittest.TestCase):

    def setUp(self):
        print("setUp")
        self.pu_test = PowerUnitModel()

    def tearDown(self):
        print("tearDown\n")

    def test_default(self):
        print("Test default mode")
        self.pu_test.__init__()
        self.assertEqual(self.pu_test._mode, 1)

    def test_mode(self):
        print("Test mode methods")
        self.pu_test.set_mode(2)
        self.assertEqual(self.pu_test._mode, 2)
        self.assertEqual(self.pu_test._mode, self.pu_test.get_mode())

if __name__ == '__main__':
    unittest.main()
