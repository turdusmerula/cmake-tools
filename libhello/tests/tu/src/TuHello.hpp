#include <cppunit/extensions/HelperMacros.h>

#include <util/hello.h>

class HelloTest : public CppUnit::TestFixture
{
public:
    CPPUNIT_TEST_SUITE(HelloTest) ;
    CPPUNIT_TEST(testHello) ;
    CPPUNIT_TEST_SUITE_END();

public:
    void setUp ()
    {
		std::cout << std::endl ;
    }

	void tearDown()
	{
	}


	void testHello()
	{
		hello() ;
	}


} ;

CPPUNIT_TEST_SUITE_REGISTRATION(HelloTest) ;
